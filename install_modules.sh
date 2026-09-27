#!/usr/bin/env bash

# ==============================================================================
# Script: install_modules.sh
# Mục đích: Cài đặt các module Python phổ biến và hiển thị thông tin hệ thống
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

echo ""
echo "===== CÀI ĐẶT MODULES PYTHON ====="
echo "Đang cài đặt: pillow, bs4, requests, pystyle, pycryptodome, colorama, httpx, urllib3..."
hash -r 2>/dev/null || true
pip install pillow bs4 requests pystyle pycryptodome colorama httpx urllib3

# Màu sắc hiển thị
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Lấy phiên bản các thành phần hệ thống
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
printf "${BOLD}${YELLOW}       THÔNG TIN HỆ THỐNG & PHIÊN BẢN${NC}\n"
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

if [ "$OPENSSL_VER" != "Chưa cài đặt" ]; then
    printf "  ${BOLD}• pyOpenSSL    :${NC} ${GREEN}%s${NC}\n" "$OPENSSL_VER"
else
    printf "  ${BOLD}• pyOpenSSL    :${NC} ${RED}%s${NC}\n" "$OPENSSL_VER"
fi

printf "${CYAN}==================================================${NC}\n"
printf "  ${BOLD}Trạng thái :${NC} ${GREEN}✔ Hoàn tất cài đặt thành công!${NC}\n"
printf "  ${BOLD}Tác giả    :${NC} HoangPC\n"
printf "  ${BOLD}Donate Momo:${NC} ${YELLOW}0865385209${NC}\n"
printf "${CYAN}==================================================${NC}\n"
echo ""
