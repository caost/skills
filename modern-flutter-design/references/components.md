# Components

자주 만들게 되는 위젯들의 모던한 구현체. 그대로 복사해 쓰거나 출발점으로.

## 1. Card

기본 Card 위젯은 너무 단조롭다. 다음 패턴을 쓴다.

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: isDark 
              ? Border.all(color: Colors.white.withOpacity(0.06)) 
              : null,
            boxShadow: isDark ? null : const [
              BoxShadow(color: Color(0x0F000000), blurRadius: 4,  offset: Offset(0, 2)),
              BoxShadow(color: Color(0x0A000000), blurRadius: 8,  offset: Offset(0, 4)),
            ],
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
```

### Bento Grid (대시보드/홈)

```dart
GridView.custom(
  gridDelegate: SliverWovenGridDelegate.count(
    crossAxisCount: 4,
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    pattern: const [
      WovenGridTile(1),
      WovenGridTile(0.5, crossAxisRatio: 0.5, alignment: AlignmentDirectional.centerStart),
    ],
  ),
  childrenDelegate: ...,
)
```

(`flutter_staggered_grid_view` 패키지 사용. 또는 `Wrap` + 직접 size 계산.)

## 2. Buttons

### Primary CTA (가장 강조)

```dart
FilledButton(
  onPressed: onPressed,
  style: FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    backgroundColor: Theme.of(context).colorScheme.primary,
  ),
  child: Text('계속하기'),
)
```

화면당 1개만. 너비 100%, 높이 52, radius 12.

### Secondary

```dart
OutlinedButton(
  onPressed: onPressed,
  style: OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    side: BorderSide(color: scheme.outlineVariant, width: 1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  child: Text('나중에'),
)
```

### Tertiary / Ghost

```dart
TextButton(
  onPressed: onPressed,
  style: TextButton.styleFrom(
    foregroundColor: scheme.onSurface,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  child: Text('취소'),
)
```

### 눌림 피드백 강화 (haptic)

```dart
import 'package:flutter/services.dart';

onPressed: () {
  HapticFeedback.lightImpact();
  // 실제 액션
}
```

## 3. Inputs

### Modern TextField

```dart
TextField(
  decoration: InputDecoration(
    hintText: '이메일',
    prefixIcon: const Icon(LucideIcons.mail, size: 20),
    filled: true,
    fillColor: scheme.surfaceContainerHighest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.primary, width: 1.5),
    ),
  ),
)
```

핵심:
- `filled: true` + `fillColor`로 배경색 — 테두리 없는 모던 룩
- focused일 때만 1.5px primary 테두리 등장
- prefix/suffix icon은 20px lucide

### Floating Label은 피하라

대신 라벨을 input 위에 별도 Text로:

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('이메일', style: textTheme.labelLarge),
    const Gap(6),
    TextField(...),
  ],
)
```

## 4. Bottom Sheet

새 화면 push 대신 시트로 처리하면 더 모던하다.

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => const _MySheet(),
);

class _MySheet extends StatelessWidget {
  const _MySheet();
  
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 36, height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [/* 컨텐츠 */],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

핵심:
- 상단 28px radius (16보다 더 큰 게 모던)
- drag handle 36×4 outlineVariant
- DraggableScrollableSheet으로 사용자가 크기 조절 가능

## 5. App Bar

기본 AppBar는 elevation/색이 어색. SliverAppBar 권장:

```dart
CustomScrollView(
  slivers: [
    SliverAppBar(
      pinned: true,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text('홈', style: textTheme.titleLarge),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(LucideIcons.bell, size: 22),
          onPressed: () {},
        ),
        const Gap(4),
      ],
    ),
    SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(...),
    ),
  ],
)
```

대형 헤더가 필요하면 `expandedHeight` + `flexibleSpace`로 collapsing 헤더.

## 6. Bottom Navigation

Material 3의 `NavigationBar` 사용 (BottomNavigationBar 아님):

```dart
NavigationBar(
  selectedIndex: _index,
  onDestinationSelected: (i) {
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  },
  destinations: const [
    NavigationDestination(icon: Icon(LucideIcons.home),     label: '홈'),
    NavigationDestination(icon: Icon(LucideIcons.search),   label: '검색'),
    NavigationDestination(icon: Icon(LucideIcons.heart),    label: '저장'),
    NavigationDestination(icon: Icon(LucideIcons.userRound),label: '프로필'),
  ],
)
```

destinations는 3–5개. 더 많으면 drawer 또는 "더보기" 통합.

## 7. List Item

```dart
class AppListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const AppListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (leading != null) ...[leading!, const Gap(12)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null) ...[
                    const Gap(2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!
            else Icon(LucideIcons.chevronRight, size: 18, color: theme.colorScheme.outline),
          ],
        ),
      ),
    );
  }
}
```

## 8. Skeleton Loader

```dart
import 'package:shimmer/shimmer.dart';

Widget skeletonCard(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Shimmer.fromColors(
    baseColor:      isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
    highlightColor: isDark ? Colors.white.withOpacity(0.10) : Colors.black.withOpacity(0.02),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 180, decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16),
        )),
        const Gap(12),
        Container(height: 16, width: 200, color: Colors.white),
        const Gap(8),
        Container(height: 12, width: 120, color: Colors.white),
      ],
    ),
  );
}
```

`CircularProgressIndicator` 가운데 띄우는 대신 항상 skeleton.

## 9. Empty State

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(LucideIcons.inbox, size: 56, color: scheme.outline),
    const Gap(16),
    Text('아직 항목이 없어요', style: textTheme.titleMedium),
    const Gap(4),
    Text(
      '첫 항목을 추가해보세요',
      style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
    ),
    const Gap(24),
    FilledButton.tonal(
      onPressed: () {},
      child: const Text('추가하기'),
    ),
  ],
)
```

3-line empty state: 아이콘 → 제목 → 설명 → 액션 버튼 (선택).
