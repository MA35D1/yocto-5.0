#!/bin/bash

# 預設變數
SRC_CODE="MA35D1"
DST1_CODE="MA35D0"
DST2_CODE="MA35H0"

SRC_CODE_LC="ma35d1"
DST1_CODE_LC="ma35d0"
DST2_CODE_LC="ma35h0"

SRC_DIR="$1"
DEST_DIR1="$2"
DEST_DIR2="$3"

if [ -z "$SRC_DIR" ] || [ -z "$DEST_DIR1" ] || [ -z "$DEST_DIR2" ]; then
    echo "Usage: $0 <SRC_folder> <DST1_folder> <DST2_folder>"
    echo "Example: $0 ./d1_folder ./d0_folder ./h0_folder"
    echo "./copy_and_replace_folder.sh meta-ma35d1 meta-ma35d0 meta-ma35h0"
    exit 1
fi

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: $SRC_DIR is not a directory."
    exit 1
fi

# 複製整個資料夾
cp -a "$SRC_DIR" "$DEST_DIR1"
cp -a "$SRC_DIR" "$DEST_DIR2"

# 內容遞迴替換
find "$DEST_DIR1" -type f -exec sed -i "s/$SRC_CODE/$DST1_CODE/g; s/$SRC_CODE_LC/$DST1_CODE_LC/g" {} +
find "$DEST_DIR2" -type f -exec sed -i "s/$SRC_CODE/$DST2_CODE/g; s/$SRC_CODE_LC/$DST2_CODE_LC/g" {} +

# 檔案與資料夾名稱遞迴替換 function
rename_files_and_dirs() {
    local target_dir="$1"
    local from_upper="$2"
    local to_upper="$3"
    local from_lower="$4"
    local to_lower="$5"
    # 先處理最深層的檔案與資料夾
    find "$target_dir" -depth | while read file; do
        # 換大寫
        newfile=$(echo "$file" | sed "s/$from_upper/$to_upper/g")
        # 換小寫
        newfile=$(echo "$newfile" | sed "s/$from_lower/$to_lower/g")
        if [ "$file" != "$newfile" ]; then
            mv "$file" "$newfile"
        fi
    done
}

# 對 DST1與DST2資料夾遞迴修正檔名與目錄名
rename_files_and_dirs "$DEST_DIR1" "$SRC_CODE" "$DST1_CODE" "$SRC_CODE_LC" "$DST1_CODE_LC"
rename_files_and_dirs "$DEST_DIR2" "$SRC_CODE" "$DST2_CODE" "$SRC_CODE_LC" "$DST2_CODE_LC"

echo "Copied, replaced content, and renamed files/dirs:"
echo "  $SRC_DIR -> $DEST_DIR1 ($SRC_CODE->$DST1_CODE, $SRC_CODE_LC->$DST1_CODE_LC)"
echo "  $SRC_DIR -> $DEST_DIR2 ($SRC_CODE->$DST2_CODE, $SRC_CODE_LC->$DST2_CODE_LC)"
