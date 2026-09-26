#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python.sh
# Mục đích: Hạ cấp Python trên Termux (hỗ trợ Python 3.12.12 và Python 3.13.13)
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

# 1. Kiểm tra kiến trúc máy
ARCH="$(uname -m)"
case "$ARCH" in
    aarch64|armv7l|arm)
        ;;
    *)
        echo "Lỗi: Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# 2. Hiển thị menu chọn phiên bản
echo "===== CHỌN PHIÊN BẢN PYTHON CẦN HẠ CẤP ====="
echo "1) Python 3.12.12"
echo "2) Python 3.13.13"
echo "0) Thoát"
read -rp "Nhập lựa chọn của bạn: " menu_choice

case "$menu_choice" in
    1)
        SELECTED_VERSION="3.12.12"
        ;;
    2)
        SELECTED_VERSION="3.13.13"
        ;;
    0)
        echo "Thoát chương trình."
        exit 0
        ;;
    *)
        echo "Lỗi: Lựa chọn không hợp lệ!"
        exit 1
        ;;
esac

# 3. Cập nhật và cài đặt các package cơ bản
echo "===== CẬP NHẬT VÀ CÀI ĐẶT PACKAGES CƠ BẢN ====="
yes | pkg update -y && yes | pkg upgrade -y && pkg i mandoc perl python-pip termux-services php wget git rust libjpeg-turbo -y && makewhatis && cargo install cargo-termux

# 4. Thực hiện hạ cấp Python theo phiên bản đã chọn
echo "===== HẠ CẤP PYTHON XUỐNG PHIÊN BẢN $SELECTED_VERSION ====="

if [ "$menu_choice" -eq 1 ]; then
    # Python 3.12.12
    case "$ARCH" in
        aarch64)
            cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/python_3.12.12_aarch64.deb | tee python_3.12.12_aarch64.deb > /dev/null && dpkg -i python_3.12.12_aarch64.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && pkg uninstall python-ensurepip-wheels -y && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/modules/python-cryptography_46.0.3_aarch64.deb | tee python-cryptography_46.0.3_aarch64.deb > /dev/null && dpkg -i python-cryptography_46.0.3_aarch64.deb && pip install "pyOpenSSL==25.3.0" --no-deps && apt-mark hold python
            ;;
        armv7l|arm)
            cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/python_3.12.12_arm.deb | tee python_3.12.12_arm.deb > /dev/null && dpkg -i python_3.12.12_arm.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && pkg uninstall python-ensurepip-wheels -y && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.12/modules/python-cryptography_46.0.3_arm.deb | tee python-cryptography_46.0.3_arm.deb > /dev/null && dpkg -i python-cryptography_46.0.3_arm.deb && pip install "pyOpenSSL==25.3.0" --no-deps && apt-mark hold python
            ;;
        *)
            echo "Kiến trúc không được hỗ trợ: $ARCH"
            exit 1
            ;;
    esac

elif [ "$menu_choice" -eq 2 ]; then
    # Python 3.13.13
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
fi

# 5. Cài đặt các module Python
echo "===== CÀI ĐẶT MODULES PYTHON ====="
pip install pillow bs4 requests pystyle pycryptodome colorama httpx urllib3

# 6. Kiểm tra phiên bản cryptography và hỏi nâng cấp
python -c "import cryptography; print('Cryptography:', cryptography.__version__)" 2>/dev/null

read -rp "Bạn có muốn nâng cấp cryptography? (y/n): " choice
case "$choice" in
    [Yy]*)
        echo "Quá trình nâng cấp có thể mất 20-30 phút."
        pip install -U cryptography
        pip install -U pyopenssl
        ;;
    *)
        echo "Bỏ qua nâng cấp cryptography."
        ;;
esac

# 7. Kiểm tra và in ra thông tin phiên bản
echo "===== THÔNG TIN HỆ THỐNG HIỆN TẠI ====="
python --version
pip --version
python -c "import cryptography; print('Cryptography:', cryptography.__version__)" 2>/dev/null

echo "=================================================="
echo "Hạ xuống phiên bản thành công, được tạo bởi HoangPC"
echo "Donate qua Momo: 0865385209"
echo "=================================================="
