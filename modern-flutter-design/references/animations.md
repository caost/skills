# Animations

2026 모션 디자인은 *기능적*이다. 사용자에게 무엇이 일어났는지 설명하는 도구로만 쓴다.

## 핵심 원칙

1. **Duration**: 150ms (마이크로) / 250ms (표준) / 400ms (큰 전환). 500ms 넘으면 답답하다.
2. **Easing**: `Curves.easeOutCubic` (들어옴), `Curves.easeInCubic` (사라짐), `Curves.easeInOutCubic` (양방향).
3. **Spring**: 인터랙션 피드백 (탭, 드래그) 은 spring physics가 자연스럽다 — `flutter_animate`의 `.scale()` + `Curves.elasticOut`.
4. **Reduced motion 존중**: `MediaQuery.of(context).disableAnimations`가 true면 duration 0으로.
5. **동시 다발 애니메이션 금지**: 한 화면에서 동시에 움직이는 것 3개 이하.

## flutter_animate 기본 패턴

```yaml
dependencies:
  flutter_animate: ^4.5.0
```

### 화면 진입 시 stagger

```dart
import 'package:flutter_animate/flutter_animate.dart';

Column(
  children: [
    Text('환영합니다'),
    Text('계정을 만들어 시작하세요'),
    FilledButton(...),
  ].animate(interval: 80.ms)
   .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
   .slideY(begin: 0.1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic),
)
```

핵심:
- `interval` 80–120ms — stagger
- `slideY(begin: 0.1)` — 살짝 아래에서 올라옴 (10% 거리)
- duration 400ms

### 카드 호버/탭 효과

```dart
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  child: AnimatedScale(
    scale: _pressed ? 0.97 : 1.0,
    duration: 150.ms,
    curve: Curves.easeOut,
    child: AppCard(...),
  ),
)
```

### 스켈레톤 → 실제 컨텐츠 페이드 전환

```dart
AnimatedSwitcher(
  duration: 300.ms,
  switchInCurve: Curves.easeOutCubic,
  child: isLoading 
    ? const SkeletonCard(key: ValueKey('skeleton'))
    : ContentCard(key: ValueKey('content'), data: data),
)
```

### Hero 트랜지션 (페이지 간 공유 요소)

```dart
// 리스트 아이템
Hero(
  tag: 'item-${item.id}',
  child: Image.network(item.imageUrl),
)

// 디테일 화면
Hero(
  tag: 'item-${item.id}',
  child: Image.network(item.imageUrl),
)
```

이미지/카드가 자연스럽게 확장되며 다음 화면으로 전환.

## 자주 쓰는 모션 레시피

### 1. Number counter

```dart
TweenAnimationBuilder<int>(
  tween: IntTween(begin: 0, end: count),
  duration: 800.ms,
  curve: Curves.easeOutQuart,
  builder: (context, value, _) => Text('$value원', style: textTheme.displayMedium),
)
```

### 2. Loading dots

```dart
Row(
  mainAxisSize: MainAxisSize.min,
  children: List.generate(3, (i) => Container(
    width: 8, height: 8, margin: const EdgeInsets.symmetric(horizontal: 3),
    decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
  ).animate(onPlay: (c) => c.repeat())
   .fadeOut(duration: 600.ms, curve: Curves.easeInOut, delay: (i * 200).ms)
   .then().fadeIn(duration: 600.ms, curve: Curves.easeInOut)),
)
```

### 3. Success check

```dart
Icon(LucideIcons.check, size: 64, color: Colors.green)
  .animate()
  .scale(begin: const Offset(0, 0), end: const Offset(1, 1),
         duration: 400.ms, curve: Curves.elasticOut)
  .then(delay: 200.ms)
  .shimmer(duration: 800.ms)
```

### 4. 페이지 전환 (route)

```dart
// MaterialPageRoute 대신 PageRouteBuilder
Navigator.push(context, PageRouteBuilder(
  transitionDuration: 350.ms,
  reverseTransitionDuration: 250.ms,
  pageBuilder: (_, __, ___) => const DetailScreen(),
  transitionsBuilder: (_, animation, __, child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  },
));
```

iOS-style이면 `CupertinoPageRoute` 그대로도 좋다.

### 5. Pull-to-refresh 모던

```dart
RefreshIndicator(
  color: scheme.primary,
  backgroundColor: scheme.surfaceContainerHighest,
  strokeWidth: 2.5,
  displacement: 40,
  onRefresh: () async {
    HapticFeedback.mediumImpact();
    await fetchData();
  },
  child: ListView(...),
)
```

## 안티패턴

- ❌ 모든 위젯에 `.animate().fadeIn()` 도배 → 정작 중요한 변화가 안 보임
- ❌ `Curves.bounceOut` 일반 UI에 사용 → 장난스러워 보임 (게임/캐주얼 앱 외 비추)
- ❌ duration 1000ms 넘기기 → 느려서 답답
- ❌ 여러 페이지에 같은 이펙트 반복 → 사용자가 무뎌짐
- ❌ 로딩 스피너 무한 회전 → 진척률을 보여주거나 skeleton 사용

## 접근성

```dart
final reduceMotion = MediaQuery.of(context).disableAnimations;

AnimatedContainer(
  duration: reduceMotion ? Duration.zero : 250.ms,
  ...
)
```

iOS "동작 줄이기", Android "애니메이션 제거" 설정을 자동으로 따른다.
