#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python3.13.sh
# Mục đích: Hạ cấp xuống Python 3.13.13 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Vai trò: Chỉ kiểm tra kiến trúc và hạ cấp Python 3.13.13, sau đó
#          tự động chuyển tiếp sang install_modules.sh
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

# Lưu lại thư mục chứa script trước khi chuyển thư mục
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

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

echo "Kiến trúc hợp lệ: $ARCH ($PKG_ARCH)"
echo ""
echo "===== BẮT ĐẦU HẠ CẤP XUỐNG PYTHON 3.13.13 ====="

# Thao tác tại thư mục HOME
cd "$HOME" || cd

# 2.1. Sửa lỗi dependencies tồn đọng (nếu có)
echo "[1/6] Kiểm tra và sửa lỗi các gói hệ thống..."
apt --fix-broken install -y >/dev/null 2>&1

# 2.2. Tải và cài đặt gói Python 3.13.13 deb
echo "[2/6] Đang tải gói Python 3.13.13 ($PKG_ARCH)..."
if ! curl -# -fsSL "$DEB_PYTHON_URL" -o "$DEB_PYTHON_FILE"; then
    echo "Lỗi: Không thể tải gói Python 3.13.13 từ GitHub!"
    exit 1
fi

echo "Đang cài đặt Python 3.13.13..."
dpkg -i "$DEB_PYTHON_FILE"
apt --fix-broken install -y >/dev/null 2>&1
rm -f "$DEB_PYTHON_FILE"

# 2.3. Cấu hình pip qua install-pip.py
echo "[3/6] Cấu hình môi trường Pip..."
curl -fsSL "https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py" | python

# 2.4. Tải và cài đặt python-cryptography 48.0.1
echo "[4/6] Đang tải và cài đặt Cryptography 48.0.1 ($PKG_ARCH)..."
curl -fsSL "$DEB_CRYPTO_URL" -o "$DEB_CRYPTO_FILE" && dpkg -i "$DEB_CRYPTO_FILE"

# 2.5. Cài đặt pyOpenSSL 26.2.0
echo "[5/6] Đang cài đặt pyOpenSSL 26.2.0..."
hash -r 2>/dev/null
pip install "pyOpenSSL==26.2.0" --no-deps

# 2.6. Khóa phiên bản Python tránh bị ghi đè khi pkg upgrade
echo "[6/6] Khóa phiên bản Python (apt-mark hold)..."
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
TARGET_RUN=""

# Ưu tiên kiểm tra thư mục gốc của dự án hoặc thư mục hiện tại
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$MODULES_SCRIPT" ]; then
    TARGET_RUN="$SCRIPT_DIR/$MODULES_SCRIPT"
elif [ -f "./$MODULES_SCRIPT" ]; then
    TARGET_RUN="./$MODULES_SCRIPT"
elif [ -f "$HOME/$MODULES_SCRIPT" ]; then
    TARGET_RUN="$HOME/$MODULES_SCRIPT"
fi

# Nếu chưa có, tải từ GitHub
if [ -z "$TARGET_RUN" ]; then
    TARGET_PATH="${SCRIPT_DIR:-.}/$MODULES_SCRIPT"
    echo "Đang tải $MODULES_SCRIPT từ GitHub..."
    if curl -fsSL "$MODULES_URL" -o "$TARGET_PATH"; then
        chmod +x "$TARGET_PATH"
        TARGET_RUN="$TARGET_PATH"
    fi
fi

if [ -n "$TARGET_RUN" ] && [ -f "$TARGET_RUN" ]; then
    echo "Khởi chạy: $TARGET_RUN..."
    echo ""
    bash "$TARGET_RUN"
else
    echo "Lỗi: Không tìm thấy và không thể tải $MODULES_SCRIPT từ GitHub!"
    exit 1
fi
