#!/bin/bash

TARGET_FOLDER="${1:-.}"
REMOVE_STRING="${2:-initramfs}"

if [ ! -d "$TARGET_FOLDER" ]; then
    echo "Usage: $0 <target_folder> [remove_string]"
    echo "Example: $0 ./yocto initramfs"
    exit 1
fi

# 批次移除含有 REMOVE_STRING 的字串
find "$TARGET_FOLDER" -type f | while read file; do
    sed -i "s/$REMOVE_STRING//g" "$file"
done

echo "已移除 $TARGET_FOLDER 內所有檔案的 \"$REMOVE_STRING\" 字串"
