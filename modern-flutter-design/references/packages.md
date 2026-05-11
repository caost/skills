# Recommended Packages

모던 Flutter 앱을 만들 때 가장 효과 좋은 pub.dev 패키지들. 검증된 것만 골랐다.

## Tier 1: 거의 모든 프로젝트에 추가

```yaml
dependencies:
  # 디자인 토큰
  google_fonts: ^6.2.1            # 1500+ 폰트, runtime 로드 또는 번들
  gap: ^3.0.1                     # SizedBox(height: x) 대신 Gap(x)
  
  # 모션
  flutter_animate: ^4.5.0         # 선언적 애니메이션 체이닝
  shimmer: ^3.0.0                 # skeleton loader
  
  # 아이콘
  lucide_icons: ^0.257.0          # Lucide 1500+ 아이콘 (모던하고 일관성 있음)
  
  # 이미지
  cached_network_image: ^3.4.1    # 자동 캐싱 + placeholder
  flutter_svg: ^2.0.10            # SVG 렌더링
```

## Tier 2: 자주 쓰임

```yaml
dependencies:
  # 그리드 / 레이아웃
  flutter_staggered_grid_view: ^0.7.0  # bento grid, masonry
  
  # 온보딩 / 캐러셀
  smooth_page_indicator: ^1.2.0   # 페이지 인디케이터
  
  # 폼 / 인풋
  flutter_form_builder: ^9.4.1    # 복잡한 폼
  pin_code_fields: ^8.0.1         # OTP 입력
  
  # 햅틱 / 시스템
  flutter_native_splash: ^2.4.0   # 네이티브 스플래시 자동 생성
  
  # 알림 / 토스트
  toastification: ^2.3.0          # 모던 토스트 (snackbar 대체)
  
  # 다이얼로그 / 시트
  modal_bottom_sheet: ^3.0.0      # 더 유연한 modal sheet
```

## Tier 3: 프로젝트별 선택

```yaml
dependencies:
  # 차트 / 데이터 시각화
  fl_chart: ^0.69.0               # 라인/바/파이 — 디자인 좋음
  syncfusion_flutter_charts: ^27.1.48  # 더 많은 차트 (commercial license 필요)
  
  # 인터랙션
  flutter_slidable: ^3.1.1        # 스와이프 액션
  reorderable_grid_view: ^2.2.8   # 드래그 재정렬
  
  # 테마
  flex_color_scheme: ^7.3.1       # 테마 빌더 (시드 컬러로 풍부한 팔레트)
  dynamic_color: ^1.7.0           # Android 12+ Material You 색 추출
  
  # 개발 편의
  flutter_screenutil: ^5.9.3      # 화면 크기 대응 (단, MediaQuery로 충분한 경우 많음)
```

## 절대 추천 안 함 (안티 패턴)

- `getwidget` — 디자인이 구식
- `awesome_dialog` — 너무 화려해서 다른 톤이랑 안 맞음
- `flutter_neumorphic` — 2026년에 neumorphism 너무 강하면 촌스러움
- `pretty_dialog` — 이름값 못함

## 패키지별 사용 팁

### google_fonts

런타임 로드는 첫 실행 시 네트워크 호출 → 프로덕션에선 번들이 안전:

```yaml
# pubspec.yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

또는 `GoogleFonts.pendingFonts` 로 프리로드.

### gap

```dart
// Before
const SizedBox(height: 16),

// After
const Gap(16),

// Row/Column 자동 감지 — 가로/세로 알아서 처리
```

### flutter_animate

체이닝으로 시퀀스:

```dart
Text('Hello')
  .animate()
  .fadeIn(duration: 300.ms)
  .slideY(begin: 0.2, curve: Curves.easeOutCubic)
  .then(delay: 200.ms)
  .shimmer()
```

리스트 stagger:

```dart
items.map((i) => Card(...)).toList()
  .animate(interval: 80.ms)
  .fadeIn(duration: 400.ms)
  .slideX(begin: -0.1)
```

### lucide_icons

```dart
import 'package:lucide_icons/lucide_icons.dart';

Icon(LucideIcons.home,   size: 22)
Icon(LucideIcons.search, size: 22)
Icon(LucideIcons.heart,  size: 22)
```

Material Icons 대비 stroke 기반이라 모던하다. size는 보통 18/20/22/24로 통일.

### cached_network_image

```dart
CachedNetworkImage(
  imageUrl: url,
  fit: BoxFit.cover,
  placeholder: (_, __) => Shimmer.fromColors(
    baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!,
    child: Container(color: Colors.white),
  ),
  errorWidget: (_, __, ___) => const Icon(LucideIcons.imageOff),
  fadeInDuration: const Duration(milliseconds: 250),
)
```

### toastification

```dart
toastification.show(
  context: context,
  type: ToastificationType.success,
  style: ToastificationStyle.flatColored,
  title: const Text('저장됨'),
  description: const Text('변경사항이 적용되었습니다'),
  alignment: Alignment.topCenter,
  autoCloseDuration: const Duration(seconds: 3),
  borderRadius: BorderRadius.circular(12),
);
```

`SnackBar`보다 위치 자유롭고 디자인 좋음.

## pubspec.yaml 시작 템플릿

```yaml
name: my_app
description: A modern Flutter app
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: ^3.5.0

dependencies:
  flutter:
    sdk: flutter
  
  # State management (택1)
  flutter_riverpod: ^2.5.1
  
  # 디자인
  google_fonts: ^6.2.1
  gap: ^3.0.1
  flutter_animate: ^4.5.0
  shimmer: ^3.0.0
  lucide_icons: ^0.257.0
  
  # 이미지
  cached_network_image: ^3.4.1
  flutter_svg: ^2.0.10
  
  # 폼/네트워킹 등 프로젝트별 추가
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
  flutter_native_splash: ^2.4.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```
