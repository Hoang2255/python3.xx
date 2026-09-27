#!/usr/bin/env bash

# ==============================================================================
# Script: setup_and_select.sh
# Mục đích: Kiểm tra kiến trúc, lựa chọn phiên bản, cập nhật gói cơ bản và
#           tự động chuyển tiếp đến script hạ cấp Python 3.12 hoặc 3.13 tương ứng.
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

# 1. Kiểm tra kiến trúc máy
ARCH="$(uname -m)"
echo "===== KIỂM TRA KIẾN TRÚC MÁY ====="
echo "Kiến trúc máy hiện tại: $ARCH"

case "$ARCH" in
    aarch64|armv7l|arm)
        echo "Kiến trúc hợp lệ: $ARCH"
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# 2. Hiển thị menu chọn phiên bản (vòng lặp đảm bảo lựa chọn hợp lệ)
while true; do
    echo ""
    echo "===== CHỌN PHIÊN BẢN PYTHON CẦN HẠ CẤP ====="
    echo "1) Python 3.12.12"
    echo "2) Python 3.13.13"
    echo "0) Thoát"
    read -rp "Nhập lựa chọn của bạn (1, 2 hoặc 0): " menu_choice

    case "$menu_choice" in
        1)
            SELECTED_VERSION="3.12.12"
            SCRIPT_URL="https://raw.githubusercontent.com/Hoang2255/python3.xx/refs/heads/main/python/python3.12/downgrade_python3.12.sh"
            SCRIPT_NAME="downgrade_python3.12.sh"
            break
            ;;
        2)
            SELECTED_VERSION="3.13.13"
            SCRIPT_URL="https://raw.githubusercontent.com/Hoang2255/python3.xx/refs/heads/main/python/python3.13/downgrade_python3.13.sh"
            SCRIPT_NAME="downgrade_python3.13.sh"
            break
            ;;
        0)
            echo "Thoát chương trình."
            exit 0
            ;;
        *)
            echo "Lỗi: Lựa chọn không hợp lệ, vui lòng nhập lại!"
            ;;
    esac
done

# 3. Cập nhật và cài đặt các package cơ bản
clear
echo "===== CẬP NHẬT VÀ CÀI ĐẶT PACKAGES CƠ BẢN ====="
echo "Phiên bản đã chọn: Python $SELECTED_VERSION"
echo ""

echo "[1/3] Đang cập nhật kho ứng dụng Termux..."
yes | pkg update -y && yes | pkg upgrade -y

echo ""
echo "[2/3] Đang cài đặt các tiện ích và gói phụ thuộc cơ bản..."
pkg install -y mandoc perl python-pip termux-services php wget git rust libjpeg-turbo curl
pkg uninstall python-ensurepip-wheels -y 2>/dev/null || true

echo ""
echo "[3/3] Cấu hình môi trường bổ trợ..."
makewhatis 2>/dev/null || true
cargo install cargo-termux 2>/dev/null || true

echo ""
echo "=================================================="
echo "Cập nhật và cài đặt packages cơ bản hoàn tất!"
echo "=================================================="

# 4. Tự động chuyển tiếp tới script hạ cấp tiếp theo
echo ""
echo "===== TIẾN TỚI HẠ CẤP PYTHON $SELECTED_VERSION ====="

TARGET_RUN=""

# 4.1. Ưu tiên kiểm tra file script có sẵn trên máy
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$SCRIPT_NAME" ]; then
    TARGET_RUN="$SCRIPT_DIR/$SCRIPT_NAME"
elif [ -f "./$SCRIPT_NAME" ]; then
    TARGET_RUN="./$SCRIPT_NAME"
fi

# 4.2. Nếu chưa có trên máy, tự động tải bản mới nhất từ GitHub
if [ -z "$TARGET_RUN" ]; then
    echo "Không tìm thấy $SCRIPT_NAME trên máy, đang tải từ GitHub..."
    echo "URL: $SCRIPT_URL"
    TARGET_PATH="${SCRIPT_DIR:-.}/$SCRIPT_NAME"
    if curl -# -fsSL "$SCRIPT_URL" -o "$TARGET_PATH"; then
        TARGET_RUN="$TARGET_PATH"
    fi
fi

# 4.3. Khởi chạy script hạ cấp tương ứng
if [ -n "$TARGET_RUN" ] && [ -f "$TARGET_RUN" ]; then
    chmod +x "$TARGET_RUN"
    echo "Khởi chạy script: $TARGET_RUN..."
    echo ""
    bash "$TARGET_RUN"
else
    echo "Lỗi: Không tìm thấy và không thể tải $SCRIPT_NAME từ GitHub!"
    exit 1
fi
