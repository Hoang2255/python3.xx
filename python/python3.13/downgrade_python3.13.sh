#!/usr/bin/env bash

# ==============================================================================
# Script: downgrade_python3.13.sh
# Mục đích: Hạ cấp xuống Python 3.13.13 trên Termux (hỗ trợ aarch64 và arm/armv7l)
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
ARCH="$(uname -m)"

# Thực hiện hạ cấp Python 3.13.13
echo "===== HẠ CẤP PYTHON XUỐNG PHIÊN BẢN 3.13.13 ====="
clear

case "$ARCH" in
    aarch64)
        cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_aarch64.deb | tee python_3.13.13-1_aarch64.deb > /dev/null && dpkg -i python_3.13.13-1_aarch64.deb && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python-ensurepip-wheels_3.13.13-1_all.deb | tee python-ensurepip-wheels_3.13.13-1_all.deb > /dev/null && dpkg -i python-ensurepip-wheels_3.13.13-1_all.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_aarch64.deb | tee python-cryptography_48.0.1_aarch64.deb > /dev/null && dpkg -i python-cryptography_48.0.1_aarch64.deb && pip install "pyOpenSSL==26.2.0" --no-deps && apt-mark hold python && rm -f python_3.13.13-1_aarch64.deb python-ensurepip-wheels_3.13.13-1_all.deb python-cryptography_48.0.1_aarch64.deb
        ;;
    armv7l|arm)
        cd && apt --fix-broken install && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python_3.13.13-1_arm.deb | tee python_3.13.13-1_arm.deb > /dev/null && dpkg -i python_3.13.13-1_arm.deb && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/python-ensurepip-wheels_3.13.13-1_all.deb | tee python-ensurepip-wheels_3.13.13-1_all.deb > /dev/null && dpkg -i python-ensurepip-wheels_3.13.13-1_all.deb && curl -fsSL https://github.com/Hoang2255/install-pip/raw/refs/heads/main/install-pip.py | python && curl -fsSL https://github.com/Hoang2255/python3.xx/raw/refs/heads/main/python/python3.13/modules/python-cryptography_48.0.1_arm.deb | tee python-cryptography_48.0.1_arm.deb > /dev/null && dpkg -i python-cryptography_48.0.1_arm.deb && pip install "pyOpenSSL==26.2.0" --no-deps && apt-mark hold python && rm -f python_3.13.13-1_arm.deb python-ensurepip-wheels_3.13.13-1_all.deb python-cryptography_48.0.1_arm.deb
        ;;
    *)
        echo "Kiến trúc không được hỗ trợ: $ARCH"
        exit 1
        ;;
esac

# Chuyển tiếp tới cài đặt modules Python
if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/install_modules.sh" ]; then
    bash "$SCRIPT_DIR/install_modules.sh"
elif [ -f "./install_modules.sh" ]; then
    bash "./install_modules.sh"
else
    curl -fsSL https://raw.githubusercontent.com/Hoang2255/python3.xx/refs/heads/main/install_modules.sh -o install_modules.sh && chmod +x install_modules.sh && bash install_modules.sh
fi
