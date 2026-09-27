#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python3.12.sh
# Mục đích: Hạ cấp xuống Python 3.12.12 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
ARCH="$(uname -m)"

# 1. Xác định package và URL theo kiến trúc máy
case "$ARCH" in
    aarch64)
        DEB_PY="python_3.12.12_aarch64.deb"
        URL_PY="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/$DEB_PY"
        DEB_CRYPTO="python-cryptography_46.0.3_aarch64.deb"
        URL_CRYPTO="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/modules/$DEB_CRYPTO"
        ;;
    armv7l|arm)
        DEB_PY="python_3.12.12_arm.deb"
        URL_PY="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/$DEB_PY"
        DEB_CRYPTO="python-cryptography_46.0.3_arm.deb"
        URL_CRYPTO="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/modules/$DEB_CRYPTO"
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# 2. Thực hiện hạ cấp Python 3.12.12
echo "===== HẠ CẤP PYTHON XUỐNG PHIÊN BẢN 3.12.12 ====="
echo "Kiến trúc máy: $ARCH"
echo ""

cd "$HOME" || cd

echo "[1/6] Kiểm tra và sửa lỗi các gói hệ thống..."
apt --fix-broken install -y >/dev/null 2>&1 || true

echo "[2/6] Đang tải và cài đặt Python 3.12.12 ($DEB_PY)..."
curl -fsSL "$URL_PY" -o "$DEB_PY" && dpkg -i "$DEB_PY"

echo "[3/6] Cấu hình môi trường Pip..."
curl -fsSL "https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py" | python
pkg uninstall python-ensurepip-wheels -y >/dev/null 2>&1 || true

echo "[4/6] Đang tải và cài đặt Cryptography 46.0.3 ($DEB_CRYPTO)..."
curl -fsSL "$URL_CRYPTO" -o "$DEB_CRYPTO" && dpkg -i "$DEB_CRYPTO"

echo "[5/6] Đang cài đặt pyOpenSSL 25.3.0..."
hash -r 2>/dev/null || true
pip install "pyOpenSSL==25.3.0" --no-deps

echo "[6/6] Khóa phiên bản Python (apt-mark hold)..."
apt-mark hold python >/dev/null 2>&1

echo "Đang dọn dẹp các file cài đặt .deb..."
rm -f "$DEB_PY" "$DEB_CRYPTO"

echo ""
echo "=================================================="
echo "Hạ xuống Python 3.12.12 thành công!"
python --version
pip --version
echo "=================================================="

# 3. Chuyển tiếp tới cài đặt modules Python
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/install_modules.sh" ]; then
    bash "$SCRIPT_DIR/install_modules.sh"
elif [ -f "./install_modules.sh" ]; then
    bash "./install_modules.sh"
else
    curl -fsSL https://raw.githubusercontent.com/Hoang2255/python3.xx/refs/heads/main/install_modules.sh -o install_modules.sh && chmod +x install_modules.sh && bash install_modules.sh
fi
