#!/bin/bash

# 1. 원본 skill 디렉토리 설정 (현재 디렉토리를 원본으로 가정)
# 직접 경로를 지정하려면 SOURCE_DIR="/path/to/your/cloned/repo" 로 수정하세요.
SOURCE_DIR="$(pwd)"

# 2. 타겟 디렉토리 배열 정의
TARGET_DIRS=(
    "$HOME/.agents/skills"
    "$HOME/.claude/skills"
    "$HOME/.gemini/skills"
)

echo "심볼릭 링크 설정을 시작합니다..."

for TARGET in "${TARGET_DIRS[@]}"; do
    # 부모 디렉토리 생성 (-p 옵션으로 상위 디렉토리까지 자동 생성)
    PARENT_DIR=$(dirname "$TARGET")
    mkdir -p "$PARENT_DIR"

    # 기존 파일이나 링크가 있는지 확인
    if [ -L "$TARGET" ]; then
        echo "알림: 이미 심볼릭 링크가 존재합니다 ($TARGET). 재설정합니다."
        rm "$TARGET"
    elif [ -d "$TARGET" ]; then
        echo "주의: 디렉토리가 이미 존재합니다 ($TARGET). 백업 후 진행합니다."
        mv "$TARGET" "${TARGET}_backup_$(date +%Y%m%d%H%M%S)"
    fi

    # 심볼릭 링크 생성
    ln -s "$SOURCE_DIR" "$TARGET"
    
    if [ $? -eq 0 ]; then
        echo "성공: $TARGET -> $SOURCE_DIR"
    else
        echo "실패: $TARGET 생성 중 오류 발생"
    fi
done

echo "모든 작업이 완료되었습니다."
