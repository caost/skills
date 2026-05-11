# Glassmorphism (Liquid Glass)

Apple iOS 18의 Liquid Glass가 모바일 디자인 메인으로 다시 올라왔다. Flutter에서는 `BackdropFilter`로 구현한다.

## 언제 쓰나

- ✅ 컨텐츠 위에 떠있는 헤더/내비게이션 바
- ✅ 사진/영상 위 정보 오버레이
- ✅ 모달/시트 배경 dim 대체
- ✅ Floating action card

## 언제 쓰지 말까

- ❌ 평면 단색 배경 위 (효과가 안 보임)
- ❌ 텍스트 가독성이 중요한 곳 (충분한 contrast 확보 어려움)
- ❌ 저사양 디바이스가 타겟인 앱 (BackdropFilter는 GPU 비용이 있음)
- ❌ 화면 전체에 도배 — 1–2 영역에만

## 기본 구현

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius borderRadius;
  final EdgeInsets padding;
  
  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.6,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.black : Colors.white;
    
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: baseColor.withOpacity(opacity),
            borderRadius: borderRadius,
            border: Border.all(
              color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
              width: 0.5,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
```

핵심 디테일:
- `ClipRRect`가 **반드시** 바깥에 있어야 blur가 모서리에 잘림
- 1px 미만 (0.5) 흰색 보더 → 유리 가장자리 광택 표현
- light에서 0.6 opacity, dark에서 0.4 opacity가 보통 균형 좋음
- blur 20 정도가 sweet spot. 너무 약하면 효과 없고, 50 넘으면 답답

## Floating Bottom Bar

```dart
Stack(
  children: [
    // 메인 컨텐츠
    ListView(...),
    
    // Floating glass bar
    Positioned(
      left: 16, right: 16, bottom: 24,
      child: GlassContainer(
        blur: 30,
        opacity: 0.7,
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: LucideIcons.home,    selected: true),
            _NavItem(icon: LucideIcons.search,  selected: false),
            _NavItem(icon: LucideIcons.heart,   selected: false),
            _NavItem(icon: LucideIcons.user,    selected: false),
          ],
        ),
      ),
    ),
  ],
)
```

## 이미지 위 오버레이 카드

```dart
Stack(
  children: [
    Image.network(coverUrl, fit: BoxFit.cover, height: 360, width: double.infinity),
    Positioned(
      left: 20, right: 20, bottom: 20,
      child: GlassContainer(
        blur: 24,
        opacity: 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white,
            )),
            const Gap(6),
            Text(subtitle, style: TextStyle(
              fontSize: 14, color: Colors.white.withOpacity(0.85),
            )),
          ],
        ),
      ),
    ),
  ],
)
```

## Dynamic blur (스크롤에 반응)

스크롤하면 헤더 blur가 강해지는 iOS-style:

```dart
class _ScreenState extends State<Screen> {
  final _scrollController = ScrollController();
  double _blur = 0;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final blur = (_scrollController.offset / 50).clamp(0.0, 20.0);
      if ((blur - _blur).abs() > 0.5) {
        setState(() => _blur = blur);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(controller: _scrollController, children: [...]),
        if (_blur > 0)
          Positioned(
            top: 0, left: 0, right: 0,
            child: GlassContainer(
              blur: _blur, opacity: _blur / 30,
              borderRadius: BorderRadius.zero,
              child: SafeArea(bottom: false, child: AppBarContent()),
            ),
          ),
      ],
    );
  }
}
```

## 성능 주의

- `BackdropFilter`는 매 프레임 GPU에서 blur를 다시 계산한다 → 화면당 2–3개 이하
- 큰 영역에 BackdropFilter를 깔면 저사양 기기에서 fps drop
- 정적 영역이면 `RepaintBoundary`로 감싸서 다시 그리기 방지:

```dart
RepaintBoundary(
  child: GlassContainer(...),
)
```

## 폴백 (저사양/저전력 모드)

```dart
final isLowEnd = ... // 디바이스 체크 로직

isLowEnd
  ? Container(  // 단색 fallback
      decoration: BoxDecoration(
        color: scheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    )
  : GlassContainer(child: child)
```
