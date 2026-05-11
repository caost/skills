# Design Tokens

모든 시각 결정의 출발점. 한 번 정해두면 화면 전체가 일관된다.

## 1. 컬러 시스템

### Material 3 seed 기반 (권장)

```dart
import 'package:flutter/material.dart';

class AppColors {
  // 브랜드 시드 — 여기만 바꾸면 전체 팔레트가 재생성됨
  static const Color seed = Color(0xFF6366F1); // indigo-500

  static ColorScheme light = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.light,
    surface: const Color(0xFFFAFAFA),
  );

  static ColorScheme dark = ColorScheme.fromSeed(
    seedColor: seed,
    brightness: Brightness.dark,
    surface: const Color(0xFF0A0A0B),
  );
}
```

### Neutral grey scale (커스텀 시)

기본 grey가 너무 푸르거나 차갑다고 느껴지면 직접 정의:

```dart
class AppNeutrals {
  static const Color n50  = Color(0xFFFAFAFA);
  static const Color n100 = Color(0xFFF4F4F5);
  static const Color n200 = Color(0xFFE4E4E7);
  static const Color n300 = Color(0xFFD4D4D8);
  static const Color n400 = Color(0xFFA1A1AA);
  static const Color n500 = Color(0xFF71717A);
  static const Color n600 = Color(0xFF52525B);
  static const Color n700 = Color(0xFF3F3F46);
  static const Color n800 = Color(0xFF27272A);
  static const Color n900 = Color(0xFF18181B);
  static const Color n950 = Color(0xFF09090B);
}
```

### 액센트 컬러 가이드

- **Primary**: 브랜드 컬러. 채도 60–80, 명도 50–60. CTA, 활성 상태.
- **Success**: emerald-500 `#10B981`
- **Warning**: amber-500 `#F59E0B`
- **Error**: rose-500 `#F43F5E` (red-500보다 부드러움)
- **Info**: sky-500 `#0EA5E9`

채도 높은 색은 면적의 5% 이내로만 사용.

## 2. 타이포그래피

### 폰트 선택

```yaml
# pubspec.yaml
dependencies:
  google_fonts: ^6.2.1
```

권장 폰트 (조합):

- **영문 + 한글**: `Pretendard` (한글) — 가장 자연스러움. `pretendard` package 또는 직접 fonts/ 디렉토리 추가
- **영문 only**: `Inter` (실용), `Plus Jakarta Sans` (개성), `Geist` (테크감)
- **iOS 느낌**: `SF Pro Display` 대체로 `Inter` + tight letter spacing

### Text theme (Material 3)

```dart
TextTheme buildTextTheme(Brightness brightness) {
  final base = GoogleFonts.interTextTheme();
  // 한글 포함이면 Pretendard 사용 권장
  
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: 36, height: 1.1, letterSpacing: -1.0, fontWeight: FontWeight.w700,
    ),
    displayMedium: base.displayMedium?.copyWith(
      fontSize: 28, height: 1.15, letterSpacing: -0.5, fontWeight: FontWeight.w700,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      fontSize: 22, height: 1.25, letterSpacing: -0.3, fontWeight: FontWeight.w600,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: 18, height: 1.3, fontWeight: FontWeight.w600,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      fontSize: 16, height: 1.5, fontWeight: FontWeight.w400,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      fontSize: 14, height: 1.5, fontWeight: FontWeight.w400,
    ),
    labelLarge: base.labelLarge?.copyWith(
      fontSize: 14, height: 1.2, letterSpacing: 0.1, fontWeight: FontWeight.w600,
    ),
  );
}
```

### 핵심 규칙

- **letter-spacing은 큰 글자에 음수**, 작은 글자엔 양수. 헤딩은 -0.5 ~ -1.0px.
- **line-height**는 본문 1.5, 헤딩 1.1–1.3.
- **글자 굵기**는 400 / 600 / 700 세 단계만. 500은 회색에 어색함.
- 한글은 영문보다 1–2px 작게 보이는 경향 있음 → Pretendard나 SUIT 사용.

## 3. Spacing

4의 배수만 사용. `gap` 패키지 권장.

```dart
class AppSpacing {
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double xxl  = 32;
  static const double xxxl = 48;
  static const double xxxxl = 64;
}

// 사용
Column(children: [
  Header(),
  Gap(AppSpacing.lg),
  Body(),
  Gap(AppSpacing.xxl),
  CTA(),
])
```

### 컨텍스트별 권장 spacing

- 화면 좌우 padding: 16–20
- 카드 내부 padding: 16–20
- 카드 사이 gap: 12
- 섹션 사이 gap: 32–48
- 리스트 아이템 간격: 8–12
- 버튼 내부 (vertical): 14–16

## 4. Border radius

```dart
class AppRadius {
  static const double sm    = 8;   // 작은 칩, 태그
  static const double md    = 12;  // 입력 필드, 작은 버튼
  static const double lg    = 16;  // 카드, 큰 버튼
  static const double xl    = 24;  // 시트, 모달
  static const double full  = 9999; // pill, FAB
}
```

원칙: **컴포넌트가 클수록 radius도 크게**. 버튼 12, 카드 16, 시트 24.

## 5. Shadow / Elevation

평평한 그림자 1개는 가짜처럼 보인다. 항상 2-layer:

```dart
class AppShadows {
  // Light mode
  static const List<BoxShadow> sm = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 1,  offset: Offset(0, 1)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 3,  offset: Offset(0, 1)),
  ];
  
  static const List<BoxShadow> md = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 4,  offset: Offset(0, 2)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 8,  offset: Offset(0, 4)),
  ];
  
  static const List<BoxShadow> lg = [
    BoxShadow(color: Color(0x14000000), blurRadius: 16, offset: Offset(0, 8)),
    BoxShadow(color: Color(0x0A000000), blurRadius: 6,  offset: Offset(0, 2)),
  ];
  
  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 32, offset: Offset(0, 16)),
    BoxShadow(color: Color(0x0F000000), blurRadius: 8,  offset: Offset(0, 4)),
  ];
}
```

다크 모드에서는 검은 배경에 검은 그림자가 안 보이므로 — `border` (1px, white@5%)로 깊이감 표현.

## 6. 통합 ThemeData

```dart
ThemeData buildTheme(Brightness brightness) {
  final colorScheme = brightness == Brightness.light 
    ? AppColors.light 
    : AppColors.dark;
    
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: buildTextTheme(brightness),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 17, fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}
```
