#!/bin/bash

# 用法: ./github_oneline_replace_folder.sh <target_folder> <search_string> <from_string> <to_string>
# 範例: ./github_oneline_replace_folder.sh meta-ma35d0 "github.com/OpenNuvoton" "MA35D0" "MA35D1"

TARGET_FOLDER=${1:-"./"}
SEARCH_STRING=${2:-"github.com/OpenNuvoton"}
FROM_STRING=${3:-"MA35D0"}
TO_STRING=${4:-"MA35D1"}

if [ -z "$TARGET_FOLDER" ] || [ -z "$SEARCH_STRING" ] || [ -z "$FROM_STRING" ] || [ -z "$TO_STRING" ]; then
    echo "Usage: $0 <target_folder> <search_string> <from_string> <to_string>"
    echo "Example: $0 ./all_repos \"github.com/OpenNuvoton\" \"MA35D0\" \"MA35D1\""
    exit 1
fi

# 只找有 SEARCH_STRING 的檔案
grep -rl --null "$SEARCH_STRING" "$TARGET_FOLDER" | while IFS= read -r -d '' file; do
  awk -v s="$SEARCH_STRING" -v f="$FROM_STRING" -v t="$TO_STRING" \
    '{if ($0 ~ s) gsub(f, t); print}' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
done
