#!/bin/bash
# -*- coding: utf-8 -*-
# created by tomriddle1234 @2025 https://github.com/tomriddle1234/footageFileOrganize

# -----------------------------
# DJI 素材分类脚本 macOS/Linux
# -----------------------------

# 修改为你的素材目录
SRC_DIR="/Users/yourname/Footages/DJI/videos"

# 检查目录是否存在
if [ ! -d "$SRC_DIR" ]; then
    echo "源目录不存在: $SRC_DIR"
    exit 1
fi

# 目标目录
DLOG_M_DIR="$SRC_DIR/dlog-m"
DLOG_DIR="$SRC_DIR/dlog"

mkdir -p "$DLOG_M_DIR"
mkdir -p "$DLOG_DIR"

echo
echo "=== 开始分析 SRT 文件并分类移动 ==="
echo "Source: $SRC_DIR"
echo

found_any=0

# 遍历 SRT 文件
for srt_file in "$SRC_DIR"/*.SRT; do
    [ -e "$srt_file" ] || continue
    found_any=1
    filename=$(basename "$srt_file")
    name="${filename%.*}"
    color=""

    # 提取第一行包含 color_md 的内容
    color_line=$(grep -i "color_md:" "$srt_file" | head -n1)

    if [ -n "$color_line" ]; then
        echo "[检测到] $filename → $color_line"
        if echo "$color_line" | grep -iq "dlog_m"; then
            color="dlog_m"
        elif echo "$color_line" | grep -iq "d_log"; then
            color="d_log"
        fi
    else
        echo "[未检测到 color_md] $filename"
    fi

    # 移动同名文件
    if [ "$color" == "dlog_m" ]; then
        echo "[DLOG-M] 移动 $name.*"
        for f in "$SRC_DIR/$name".*; do
            [ -e "$f" ] || continue
            mv -f "$f" "$DLOG_M_DIR/"
        done
    elif [ "$color" == "d_log" ]; then
        echo "[DLOG] 移动 $name.*"
        for f in "$SRC_DIR/$name".*; do
            [ -e "$f" ] || continue
            mv -f "$f" "$DLOG_DIR/"
        done
    else
        echo "[跳过——未知类型] $filename"
    fi

    echo
done

if [ "$found_any" -eq 0 ]; then
    echo "没有找到任何 .SRT 文件。"
fi

echo
echo "=== 分类完成 ==="
