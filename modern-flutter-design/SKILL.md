---
name: modern-flutter-design
description: Use this skill when designing or styling Flutter app UI to look modern, sleek, and on-trend with 2026 mobile design language. Triggers include any request to "make this look better", "modernize the UI", "the default Flutter look is ugly", "iOS-style design", "더 세련되게", "디자인 개선", building landing/login/onboarding/dashboard/profile/settings screens, theming apps with Material 3 or Cupertino, applying glassmorphism / liquid glass / bento grid / bottom sheets / skeleton loaders / microinteractions / dark mode. Use whenever Claude is about to write Flutter widget code that the user will see — pick design tokens, components, and motion patterns from this skill instead of using raw Material defaults.
---

# Modern Flutter Design (2026)

Flutter 기본 Material 룩은 좋은 출발점이지만 그대로 쓰면 "Flutter처럼 보이는 앱"이 된다. 이 skill은 2026년 현재 잘 만든 모바일 앱들이 공유하는 디자인 언어를 Flutter로 구현하는 가이드다.

## 핵심 원칙

다음 5가지를 머리에 두고 모든 위젯을 만든다.

1. **의도된 미니멀리즘** — 빈 공간이 아니라 *호흡*. 한 화면당 primary action은 1개, 위계는 typography와 spacing으로만 잡는다.
2. **부드러운 깊이감** — flat은 끝났다. 살짝 들린 카드, 8–24px blur shadow, 12–20px radius. 단 neumorphism처럼 과하면 안 된다.
3. **기능적 모션** — 애니메이션은 장식이 아니라 상태 전이를 설명하는 도구. spring physics, 200–400ms, `prefers-reduced-motion` 존중.
4. **컨텍스트 컨테이너** — full-screen route 대신 bottom sheet, dialog 대신 inline disclosure. 사용자를 다른 화면으로 끌고 가지 말 것.
5. **bold accent + neutral base** — 채도 높은 색은 1–2개 액센트로만, 나머지는 neutral grey scale. 다크 모드는 옵션이 아니라 기본.

## 디자인 결정 트리

작업 시작 전 다음 순서로 판단:

```
사용자가 화면/위젯을 만들어 달라고 했다
  │
  ├─ 디자인 토큰(색/폰트/spacing)이 정의되어 있나?
  │    └─ NO  → references/design-tokens.md 먼저 적용
  │
  ├─ 어떤 컴포넌트 패턴이 필요한가?
  │    └─ references/components.md 에서 매칭
  │
  ├─ 상태 전이/사용자 피드백이 있나?
  │    └─ YES → references/animations.md
  │
  ├─ 오버레이/시트/배경 흐림이 있나?
  │    └─ YES → references/glassmorphism.md
  │
  └─ 다크 모드 대응 필요한가?
       └─ 거의 항상 YES → references/dark-mode.md
```

## 절대 하지 말 것

- 기본 `ThemeData()` 그대로 쓰기 → 항상 `ColorScheme.fromSeed` + 커스텀 textTheme
- `BoxShadow` 1개로 그림자 처리 → 최소 2-layer shadow (ambient + key)
- 모든 버튼 같은 elevation → primary는 들리고, secondary는 평평하게
- 화면 전환마다 새 route push → modal sheet으로 해결되는지 먼저 검토
- 로딩 시 `CircularProgressIndicator` 가운데 띄우기 → skeleton loader 사용
- `Padding(padding: EdgeInsets.all(16))` 산발적 사용 → spacing 토큰화 (4/8/12/16/24/32/48)
- icon에 `Icons.xxx` 그대로 → `lucide_icons` 또는 custom SVG로 일관성
- 모서리 radius 제각각 → 4/8/12/16/24/full 중에서만 선택

## 추천 pub.dev 패키지

새 프로젝트라면 다음을 기본 dependency로 깔고 시작:

```yaml
dependencies:
  google_fonts: ^6.2.1            # Inter, Pretendard, Plus Jakarta Sans
  flutter_animate: ^4.5.0         # 선언적 애니메이션 체이닝
  shimmer: ^3.0.0                 # skeleton loader
  gap: ^3.0.1                     # SizedBox 대신 Gap(16)
  lucide_icons: ^0.257.0          # 모던 아이콘 세트
  flutter_svg: ^2.0.10            # 커스텀 일러스트
  smooth_page_indicator: ^1.2.0   # 온보딩
  flutter_native_splash: ^2.4.0   # 스플래시
```

상세는 `references/packages.md`.

## 시작 체크리스트

새 화면을 만들 때 이 순서로:

1. `Scaffold`의 `backgroundColor`를 `Theme.of(context).colorScheme.surface`로 명시
2. `SafeArea` 안에 컨텐츠 — notch/홈 인디케이터 충돌 방지
3. 가장 위 `Padding` 16–24, 좌우 16–20 (브랜드에 따라 조정)
4. 헤더는 `SliverAppBar`로 — 스크롤 시 자연스럽게 collapse
5. 리스트가 길면 `CustomScrollView` + `SliverList` 조합
6. CTA는 화면 하단 fixed가 아니라면 `Padding(EdgeInsets.only(bottom: 24))`로 호흡 확보
7. 로딩/에러/빈 상태 모두 처리 — skeleton, illustration, retry 버튼

## 참고 문서

- `references/design-tokens.md` — 색, 타이포, spacing, radius, shadow 토큰 + 코드
- `references/components.md` — 자주 쓰는 컴포넌트 (카드, 버튼, 입력, 시트) 코드 스니펫
- `references/animations.md` — 모션 설계 원칙 + flutter_animate 패턴
- `references/glassmorphism.md` — Liquid Glass 스타일 (BackdropFilter)
- `references/dark-mode.md` — Material 3 + Cupertino 다크 테마 셋업
- `references/packages.md` — 패키지별 사용 가이드
