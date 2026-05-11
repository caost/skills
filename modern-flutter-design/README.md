# modern-flutter-design

Claude Code 용 Flutter 모던 디자인 skill. 2026년 기준 모바일 앱 디자인 트렌드를 반영한 Flutter 위젯/테마/모션 가이드.

## 무엇을 해주나

Claude Code가 Flutter 위젯 코드를 작성할 때 자동으로 활성화되어:

- 기본 Material 룩 대신 **모던한 디자인 토큰** (컬러, 타이포, spacing, shadow) 적용
- **Bento grid, glassmorphism, bottom sheet, skeleton loader** 같은 2026 패턴 사용
- **Material 3 + Cupertino** 혼합으로 iOS/Android 자연스러운 룩
- **다크 모드 우선** 설계
- **검증된 pub.dev 패키지** 추천 + 사용 가이드

## 설치 (프로젝트 단위)

Flutter 프로젝트 루트에서:

```bash
mkdir -p .claude/skills
cp -r modern-flutter-design .claude/skills/
```

git에 커밋하면 팀원도 자동으로 같이 쓰게 됨:

```bash
git add .claude/skills/modern-flutter-design
git commit -m "chore: add modern-flutter-design skill"
```

## 설치 (전역)

```bash
mkdir -p ~/.claude/skills
cp -r modern-flutter-design ~/.claude/skills/
```

## 사용

따로 호출할 필요 없음. Claude Code가 자연어 요청 보고 자동 활성화한다:

- "로그인 화면 만들어줘"
- "이 카드 디자인 더 세련되게 바꿔줘"
- "다크 모드 추가해줘"
- "온보딩 애니메이션 넣어줘"

## 추가 추천 — Flutter 공식 skills

Flutter 팀에서 공식 운영하는 43개 skills 저장소도 같이 설치하면 시너지 좋음:

```bash
cd .claude/skills
git clone https://github.com/flutter/skills.git flutter-official
```

특히 같이 쓰면 좋은 것:
- `flutter-theming-apps` — 테마 시스템 깊은 이해
- `flutter-building-layouts` — 레이아웃 패턴
- `flutter-animating-apps` — 애니메이션 구현
- `flutter-architecting-apps` — 폴더 구조

이 modern-flutter-design은 *디자인 의사결정*을 담당하고, flutter 공식 skills는 *구현 디테일*을 담당하므로 역할이 다르다.

## 구조

```
modern-flutter-design/
├── SKILL.md                          # 메인 가이드 (Claude가 먼저 읽음)
└── references/
    ├── design-tokens.md              # 컬러/타이포/spacing/shadow
    ├── components.md                 # 카드/버튼/입력/시트/리스트
    ├── animations.md                 # 모션 원칙 + flutter_animate
    ├── glassmorphism.md              # Liquid Glass 구현
    ├── dark-mode.md                  # 다크 모드 셋업
    └── packages.md                   # 추천 패키지
```

Claude는 SKILL.md를 항상 읽고, references는 필요할 때만 로드한다.

## 커스터마이징

자기 브랜드에 맞게 SKILL.md / design-tokens.md의 색·폰트·spacing을 직접 수정해 쓰면 된다. 특히 `AppColors.seed` 와 폰트 패밀리는 프로젝트별로 다를 가능성이 높음.
