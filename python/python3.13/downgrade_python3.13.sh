#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python3.13.sh
# Mục đích: Hạ cấp xuống Python 3.13.13 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
ARCH="$(uname -m)"

# 1. Xác định package và URL theo kiến trúc máy
case "$ARCH" in
    aarch64)
        DEB_PY="python_3.13.13-1_aarch64.deb"
        URL_PY="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/$DEB_PY"
        DEB_CRYPTO="python-cryptography_48.0.1_aarch64.deb"
        URL_CRYPTO="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/$DEB_CRYPTO"
        ;;
    armv7l|arm|armv8l)
        DEB_PY="python_3.13.13-1_arm.deb"
        URL_PY="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/$DEB_PY"
        DEB_CRYPTO="python-cryptography_48.0.1_arm.deb"
        URL_CRYPTO="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/$DEB_CRYPTO"
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

DEB_ENSUREPIP="python-ensurepip-wheels_3.13.13-1_all.deb"
URL_ENSUREPIP="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/$DEB_ENSUREPIP"

# 2. Thực hiện hạ cấp Python 3.13.13
echo "===== HẠ CẤP PYTHON XUỐNG PHIÊN BẢN 3.13.13 ====="
echo "Kiến trúc máy: $ARCH"
echo ""

cd "$HOME" || cd

echo "[1/6] Kiểm tra và sửa lỗi các gói hệ thống..."
apt --fix-broken install -y >/dev/null 2>&1 || true

echo "[2/6] Đang tải và cài đặt Python 3.13.13 ($DEB_PY)..."
curl -fsSL "$URL_PY" -o "$DEB_PY" && dpkg -i "$DEB_PY"

echo "[3/6] Đang tải và cài đặt ensurepip-wheels..."
curl -fsSL "$URL_ENSUREPIP" -o "$DEB_ENSUREPIP" && dpkg -i "$DEB_ENSUREPIP"

echo "[4/6] Cấu hình môi trường Pip..."
curl -fsSL "https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py" | python

echo "[5/6] Đang tải và cài đặt Cryptography 48.0.1 ($DEB_CRYPTO)..."
curl -fsSL "$URL_CRYPTO" -o "$DEB_CRYPTO" && dpkg -i "$DEB_CRYPTO"

echo "[6/6] Đang cài đặt pyOpenSSL 26.2.0..."
hash -r 2>/dev/null || true
pip install "pyOpenSSL==26.2.0" --no-deps

echo "Khóa phiên bản Python (apt-mark hold)..."
apt-mark hold python >/dev/null 2>&1

echo "Đang dọn dẹp các file cài đặt .deb..."
rm -f "$DEB_PY" "$DEB_ENSUREPIP" "$DEB_CRYPTO"

echo ""
echo "=================================================="
echo "Hạ cấp Python 3.13.13 thành công!"
echo "=================================================="
