# Dark Mode

다크 모드는 옵션이 아니라 기본. 시스템 설정을 따르되 사용자가 선택할 수 있어야 한다.

## 1. 기본 설정

```dart
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system, // 시스템 따라감
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const HomeScreen(),
    );
  }
}
```

`ThemeMode`:
- `system` — OS 설정 따라감 (기본)
- `light` / `dark` — 강제

## 2. 상태 관리로 토글 (Riverpod 예시)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _load();
  }
  
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode');
    if (saved != null) {
      state = ThemeMode.values.firstWhere(
        (m) => m.name == saved,
        orElse: () => ThemeMode.system,
      );
    }
  }
  
  Future<void> set(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode.name);
  }
}
```

```dart
// App 위젯
final themeMode = ref.watch(themeModeProvider);
return MaterialApp(
  themeMode: themeMode,
  theme: buildTheme(Brightness.light),
  darkTheme: buildTheme(Brightness.dark),
  ...
);
```

## 3. 다크 모드 컬러 원칙

### 순수 검정 피하기

`#000000` 대신 살짝 들뜬 neutral:

```dart
static const Color darkBg          = Color(0xFF0A0A0B);  // surface
static const Color darkBgElevated  = Color(0xFF18181B);  // surfaceContainer
static const Color darkBgHigher    = Color(0xFF27272A);  // surfaceContainerHigh
```

OLED 절전이 목적이라면 `#000000`도 OK이지만, 일반적으로 `#0A0A0B`가 더 부드럽다.

### Elevation = 더 밝게

다크 모드에서는 elevation이 그림자가 아니라 **더 밝은 색**으로 표현된다:

```dart
// Light mode: 카드는 surface보다 살짝 어둡거나 그림자
// Dark mode: 카드는 surface보다 살짝 밝게
final cardColor = isDark 
  ? scheme.surfaceContainerHighest  // 더 밝음
  : scheme.surface;
```

Material 3는 이걸 자동으로 처리해주므로 `surfaceContainer`, `surfaceContainerLow/High/Highest`를 의미에 맞게 쓰면 된다.

### 텍스트 contrast

순백 `#FFFFFF`도 다크 배경에서 너무 강하다 → `#FAFAFA` 또는 `Colors.white.withOpacity(0.92)`.

## 4. 시스템 UI 색 동기화

상태바/네비게이션바 색을 테마 따라 자동 변경:

```dart
import 'package:flutter/services.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: brightness == Brightness.dark 
        ? Brightness.light 
        : Brightness.dark,
      systemNavigationBarColor: brightness == Brightness.dark 
        ? const Color(0xFF0A0A0B) 
        : Colors.white,
      systemNavigationBarIconBrightness: brightness == Brightness.dark 
        ? Brightness.light 
        : Brightness.dark,
    ));
    
    return MaterialApp(...);
  }
}
```

또는 화면별로 `AnnotatedRegion`:

```dart
AnnotatedRegion<SystemUiOverlayStyle>(
  value: SystemUiOverlayStyle.dark,
  child: Scaffold(...),
)
```

## 5. 이미지/일러스트 대응

### 옵션 A: 두 버전 준비

```dart
Image.asset(isDark ? 'assets/hero_dark.png' : 'assets/hero_light.png')
```

### 옵션 B: SVG color mode

```dart
SvgPicture.asset(
  'assets/icon.svg',
  colorFilter: ColorFilter.mode(scheme.onSurface, BlendMode.srcIn),
)
```

### 옵션 C: 아예 다크 친화적 일러스트만 사용

투명 배경 + 채도 낮은 색 위주의 일러스트는 양쪽에서 다 잘 보인다.

## 6. 컬러 cheat sheet

| 의미 | Light | Dark |
|------|-------|------|
| 배경 | `#FAFAFA` | `#0A0A0B` |
| 카드 | `#FFFFFF` | `#18181B` |
| 카드 elevated | `#F4F4F5` | `#27272A` |
| 텍스트 primary | `#18181B` | `#FAFAFA` |
| 텍스트 secondary | `#52525B` | `#A1A1AA` |
| 텍스트 tertiary | `#A1A1AA` | `#71717A` |
| 보더 | `#E4E4E7` | `rgba(255,255,255,0.08)` |
| 디바이더 | `#F4F4F5` | `rgba(255,255,255,0.04)` |

## 7. 테스트

다크 모드 작업 후 반드시:

1. 시스템 설정 토글하면서 모든 화면 점검
2. 양쪽 모두에서 텍스트 contrast 4.5:1 이상 (WCAG AA)
3. 이미지/그림자/borderColor 다 적절한지
4. 전환 시 깜빡임 없는지 (대부분 `Material` widget으로 감싸면 해결)

도구: Flutter Inspector → "Toggle Brightness" 버튼.
