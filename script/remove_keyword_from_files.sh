#!/bin/bash

TARGET_FOLDER="${1:-.}"
REMOVE_KEYWORD="${2:-UBOOT_CONFIG\[initramfs\]}"

if [ ! -d "$TARGET_FOLDER" ]; then
    echo "Usage: $0 <target_folder> [remove_keyword]"
    echo "Example: $0 ./yocto 'UBOOT_CONFIG[initramfs]'"
    exit 1
fi

# 批次移除含有 REMOVE_KEYWORD 的行
grep -rl "$REMOVE_KEYWORD" "$TARGET_FOLDER" | while read file; do
    sed -i "/$REMOVE_KEYWORD/d" "$file"
done

echo "已移除 $TARGET_FOLDER 內所有檔案的 $REMOVE_KEYWORD 相關設定行"
