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

echo ""
echo "=================================================="
echo "===== THÔNG TIN HỆ THỐNG HIỆN TẠI ====="
echo "=================================================="
python --version 2>&1 || true
pip --version 2>&1 || true
python -c "import cryptography; print('Cryptography:', cryptography.__version__)" 2>/dev/null || echo "Cryptography: Chưa được cài đặt"
python -c "import OpenSSL; print('pyOpenSSL:', OpenSSL.__version__)" 2>/dev/null || true

clear
echo ""
echo "=================================================="
echo "Cài đặt hoàn tất! Script được tối ưu bởi HoangPC"
echo "Donate qua Momo: 0865385209"
echo "=================================================="
