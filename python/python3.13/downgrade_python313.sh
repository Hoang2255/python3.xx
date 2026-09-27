#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python313.sh
# Mục đích: Hạ cấp xuống Python 3.13.13 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

# 1. Kiểm tra kiến trúc máy
ARCH="$(uname -m)"
echo "===== KIỂM TRA KIẾN TRÚC MÁY ====="
echo "Kiến trúc máy phát hiện: $ARCH"

case "$ARCH" in
    aarch64|armv7l|arm)
        echo "Kiến trúc hợp lệ ($ARCH), chuẩn bị hạ cấp xuống Python 3.13.13..."
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# 2. Thực hiện hạ cấp xuống Python 3.13.13
echo ""
echo "===== BẮT ĐẦU HẠ CẤP XUỐNG PYTHON 3.13.13 ($ARCH) ====="

case "$ARCH" in
    aarch64)
        cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_aarch64.deb | tee python_3.13.13-1_aarch64.deb > /dev/null && dpkg -i python_3.13.13-1_aarch64.deb && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python-ensurepip-wheels_3.13.13-1_all.deb | tee python-ensurepip-wheels_3.13.13-1_all.deb > /dev/null && dpkg -i python-ensurepip-wheels_3.13.13-1_all.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_aarch64.deb | tee python-cryptography_48.0.1_aarch64.deb > /dev/null && dpkg -i python-cryptography_48.0.1_aarch64.deb && pip install "pyOpenSSL==26.2.0" --no-deps && apt-mark hold python
        ;;
    armv7l|arm)
        cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_arm.deb | tee python_3.13.13-1_arm.deb > /dev/null && dpkg -i python_3.13.13-1_arm.deb && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python-ensurepip-wheels_3.13.13-1_all.deb | tee python-ensurepip-wheels_3.13.13-1_all.deb > /dev/null && dpkg -i python-ensurepip-wheels_3.13.13-1_all.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_arm.deb | tee python-cryptography_48.0.1_arm.deb > /dev/null && dpkg -i python-cryptography_48.0.1_arm.deb && pip install "pyOpenSSL==26.2.0" --no-deps && apt-mark hold python
        ;;
    *)
        echo "Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# 3. Kiểm tra và in ra thông tin hệ thống sau khi hạ cấp
clear
echo "===== THÔNG TIN HỆ THỐNG HIỆN TẠI ====="
python --version
pip --version
python -c "import cryptography; print('Cryptography:', cryptography.__version__)" 2>/dev/null

echo "=================================================="
echo "Hạ xuống Python 3.13.13 thành công! Tạo bởi HoangPC"
echo "Donate qua Momo: 0865385209"
echo "=================================================="

# 4. Tùy chọn chuyển tiếp sang cài đặt modules
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/install_modules.sh" ]; then
    echo ""
    read -rp "Bạn có muốn tiếp tục chạy cài đặt modules Python (install_modules.sh)? (y/n): " run_mod
    case "$run_mod" in
        [Yy]*)
            bash "$SCRIPT_DIR/install_modules.sh"
            ;;
        *)
            echo "Bạn có thể tự cài đặt modules sau bằng lệnh: bash install_modules.sh"
            ;;
    esac
fi
