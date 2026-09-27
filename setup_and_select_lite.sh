#!/usr/bin/env bash

# ==============================================================================
# Script: setup_and_select_lite.sh
# Mục đích: Kiểm tra kiến trúc, lựa chọn phiên bản, cập nhật gói cơ bản và
#           hạ cấp Python (Bản Lite: không tự động cài đặt thêm các modules phụ).
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

# 1. Kiểm tra kiến trúc máy
ARCH="$(uname -m)"
echo "===== KIỂM TRA KIẾN TRÚC MÁY ====="
echo "Kiến trúc máy hiện tại: $ARCH"

case "$ARCH" in
    aarch64|armv7l|arm|armv8l)
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
    echo "===== CHỌN PHIÊN BẢN PYTHON CẦN HẠ CẤP (BẢN LITE) ====="
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
echo "Phiên bản đã chọn: Python $SELECTED_VERSION (Bản Lite)"
echo ""

echo "[1/3] Đang cập nhật kho ứng dụng Termux..."
yes | pkg update -y && yes | pkg upgrade -y

echo ""
echo "[2/3] Đang cài đặt các tiện ích và gói phụ thuộc cơ bản..."
pkg install -y mandoc python-pip wget git curl
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
    if ! bash "$TARGET_RUN"; then
        echo ""
        echo "Lỗi: Quá trình hạ cấp Python $SELECTED_VERSION thất bại!"
        exit 1
    fi
else
    echo "Lỗi: Không tìm thấy và không thể tải $SCRIPT_NAME từ GitHub!"
    exit 1
fi

# 5. Kiểm tra và hiển thị thông tin phiên bản hệ thống
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

hash -r 2>/dev/null || true

PY_VER=$(python -c "import platform; print(platform.python_version())" 2>/dev/null)
[ -z "$PY_VER" ] && PY_VER=$(python --version 2>&1 | awk '{print $2}')
[ -z "$PY_VER" ] && PY_VER="Chưa cài đặt"

PIP_VER=$(python -c "import pip; print(pip.__version__)" 2>/dev/null)
[ -z "$PIP_VER" ] && PIP_VER=$(pip --version 2>/dev/null | awk '{print $2}')
[ -z "$PIP_VER" ] && PIP_VER="Chưa cài đặt"

CRYPTO_VER=$(python -c "import cryptography; print(cryptography.__version__)" 2>/dev/null)
[ -z "$CRYPTO_VER" ] && CRYPTO_VER="Chưa cài đặt"

OPENSSL_VER=$(python -c "import OpenSSL; print(OpenSSL.__version__)" 2>/dev/null)
[ -z "$OPENSSL_VER" ] && OPENSSL_VER="Chưa cài đặt"

echo ""
printf "${CYAN}==================================================${NC}\n"
printf "${BOLD}${YELLOW}       THÔNG TIN HỆ THỐNG & PHIÊN BẢN (LITE)${NC}\n"
printf "${CYAN}==================================================${NC}\n"

if [ "$PY_VER" != "Chưa cài đặt" ]; then
    printf "  ${BOLD}• Python       :${NC} ${GREEN}%s${NC}\n" "$PY_VER"
else
    printf "  ${BOLD}• Python       :${NC} ${RED}%s${NC}\n" "$PY_VER"
fi

if [ "$PIP_VER" != "Chưa cài đặt" ]; then
    printf "  ${BOLD}• Pip          :${NC} ${GREEN}%s${NC}\n" "$PIP_VER"
else
    printf "  ${BOLD}• Pip          :${NC} ${RED}%s${NC}\n" "$PIP_VER"
fi

if [ "$CRYPTO_VER" != "Chưa cài đặt" ]; then
    printf "  ${BOLD}• Cryptography :${NC} ${GREEN}%s${NC}\n" "$CRYPTO_VER"
else
    printf "  ${BOLD}• Cryptography :${NC} ${RED}%s${NC}\n" "$CRYPTO_VER"
fi

OPENSSL_VER=$(python -c "import importlib.metadata as m; print(m.version('pyOpenSSL'))" 2>/dev/null || echo "Chưa cài đặt")

if [ "$OPENSSL_VER" != "Chưa cài đặt" ]; then
    printf "  ${BOLD}• pyOpenSSL    :${NC} ${GREEN}%s${NC}\n" "$OPENSSL_VER"
else
    printf "  ${BOLD}• pyOpenSSL    :${NC} ${RED}%s${NC}\n" "$OPENSSL_VER"
fi

printf "${CYAN}==================================================${NC}\n"
printf "  ${BOLD}Trạng thái :${NC} ${GREEN}✔ Hoàn tất hạ cấp thành công (Bản Lite)!${NC}\n"
printf "  ${BOLD}Tác giả    :${NC} HoangPC\n"
printf "  ${BOLD}Donate Momo:${NC} ${YELLOW}0865385209${NC}\n"
printf "${CYAN}==================================================${NC}\n"
echo ""
