#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python313.sh / downgrade_python3.13.sh
# Mục đích: Hạ cấp xuống Python 3.13.13 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Vai trò: Chỉ thực hiện kiểm tra kiến trúc và hạ cấp Python 3.13.13, sau đó
#          tự động chuyển tiếp sang install_modules.sh
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

# 1. Kiểm tra kiến trúc máy
ARCH="$(uname -m)"
echo "===== KIỂM TRA KIẾN TRÚC MÁY ====="
echo "Kiến trúc máy phát hiện: $ARCH"

case "$ARCH" in
    aarch64)
        PKG_ARCH="aarch64"
        DEB_PYTHON_URL="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_aarch64.deb"
        DEB_PYTHON_FILE="python_3.13.13-1_aarch64.deb"
        DEB_CRYPTO_URL="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_aarch64.deb"
        DEB_CRYPTO_FILE="python-cryptography_48.0.1_aarch64.deb"
        ;;
    armv7l|arm)
        PKG_ARCH="arm"
        DEB_PYTHON_URL="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_arm.deb"
        DEB_PYTHON_FILE="python_3.13.13-1_arm.deb"
        DEB_CRYPTO_URL="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_arm.deb"
        DEB_CRYPTO_FILE="python-cryptography_48.0.1_arm.deb"
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

DEB_WHEELS_URL="https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python-ensurepip-wheels_3.13.13-1_all.deb"
DEB_WHEELS_FILE="python-ensurepip-wheels_3.13.13-1_all.deb"

echo "Kiến trúc hợp lệ: $ARCH ($PKG_ARCH)"
echo ""
echo "===== BẮT ĐẦU HẠ CẤP XUỐNG PYTHON 3.13.13 ====="

# Thao tác tại thư mục HOME
cd "$HOME" || cd

# 2.1. Sửa lỗi dependencies tồn đọng (nếu có)
echo "[1/7] Kiểm tra và sửa lỗi các gói hệ thống..."
apt --fix-broken install -y >/dev/null 2>&1

# 2.2. Tải và cài đặt gói Python 3.13.13 deb
echo "[2/7] Đang tải gói Python 3.13.13 ($PKG_ARCH)..."
if ! curl -# -fsSL "$DEB_PYTHON_URL" -o "$DEB_PYTHON_FILE"; then
    echo "Lỗi: Không thể tải gói Python 3.13.13 từ GitHub!"
    exit 1
fi

echo "Đang cài đặt Python 3.13.13..."
dpkg -i "$DEB_PYTHON_FILE"
apt --fix-broken install -y >/dev/null 2>&1
rm -f "$DEB_PYTHON_FILE"

# 2.3. Tải và cài đặt ensurepip-wheels
echo "[3/7] Đang tải và cài đặt ensurepip-wheels..."
if curl -# -fsSL "$DEB_WHEELS_URL" -o "$DEB_WHEELS_FILE"; then
    dpkg -i "$DEB_WHEELS_FILE"
    apt --fix-broken install -y >/dev/null 2>&1
    rm -f "$DEB_WHEELS_FILE"
else
    echo "Cảnh báo: Không thể tải gói ensurepip-wheels!"
fi

# 2.4. Cấu hình pip qua install-pip.py
echo "[4/7] Cấu hình môi trường Pip..."
if ! curl -fsSL "https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py" | python; then
    echo "Cảnh báo: Không thể chạy install-pip.py tự động, chuyển sang python -m ensurepip..."
    python -m ensurepip --upgrade >/dev/null 2>&1 || true
fi

# 2.5. Tải và cài đặt python-cryptography 48.0.1
echo "[5/7] Đang tải gói Cryptography 48.0.1 ($PKG_ARCH)..."
if curl -# -fsSL "$DEB_CRYPTO_URL" -o "$DEB_CRYPTO_FILE"; then
    echo "Đang cài đặt Cryptography..."
    dpkg -i "$DEB_CRYPTO_FILE"
    apt --fix-broken install -y >/dev/null 2>&1
    rm -f "$DEB_CRYPTO_FILE"
else
    echo "Cảnh báo: Không thể tải gói deb Cryptography từ GitHub!"
fi

# 2.6. Cài đặt pyOpenSSL 26.2.0
echo "[6/7] Đang cài đặt pyOpenSSL 26.2.0..."
hash -r 2>/dev/null
pip install "pyOpenSSL==26.2.0" --no-deps

# 2.7. Khóa phiên bản Python tránh bị ghi đè khi pkg upgrade
echo "[7/7] Khóa phiên bản Python (apt-mark hold)..."
apt-mark hold python >/dev/null 2>&1

echo ""
echo "=================================================="
echo "Hạ xuống Python 3.13.13 thành công!"
python --version
pip --version
echo "=================================================="

# 3. Tự động chuyển tiếp sang script tiếp theo: install_modules.sh
MODULES_URL="https://raw.githubusercontent.com/Hoang2255/python3.xx/refs/heads/main/install_modules.sh"
MODULES_SCRIPT="install_modules.sh"

echo ""
echo "===== TIẾN TỚI CÀI ĐẶT MODULES PYTHON ====="
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
TARGET_RUN=""

if [ -f "$MODULES_SCRIPT" ]; then
    TARGET_RUN="$MODULES_SCRIPT"
elif [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$MODULES_SCRIPT" ]; then
    TARGET_RUN="$SCRIPT_DIR/$MODULES_SCRIPT"
elif [ -f "$HOME/$MODULES_SCRIPT" ]; then
    TARGET_RUN="$HOME/$MODULES_SCRIPT"
fi

if [ -n "$TARGET_RUN" ]; then
    echo "Khởi chạy $TARGET_RUN..."
    bash "$TARGET_RUN"
elif curl -fsSL "$MODULES_URL" -o "$MODULES_SCRIPT"; then
    chmod +x "$MODULES_SCRIPT"
    echo "Khởi chạy $MODULES_SCRIPT..."
    bash "$MODULES_SCRIPT"
else
    echo "Lỗi: Không tìm thấy và không thể tải $MODULES_SCRIPT từ GitHub!"
    exit 1
fi
