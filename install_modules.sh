#!/usr/bin/env bash

# ==============================================================================
# Script: install_modules.sh
# Mục đích: Cài đặt các module Python, kiểm tra phiên bản và tùy chọn nâng cấp Cryptography
# Tác giả: HoangPC
# Donate qua Momo: 0865385209
# ==============================================================================

# 1. Cài đặt các module Python phổ biến
clear
echo "===== CÀI ĐẶT MODULES PYTHON ====="
echo "Đang cài đặt: pillow, bs4, requests, pystyle, pycryptodome, colorama, httpx, urllib3..."
hash -r 2>/dev/null
pip install pillow bs4 requests pystyle pycryptodome colorama httpx urllib3

# 2. Kiểm tra phiên bản cryptography và hỏi nâng cấp
echo ""
echo "===== KIỂM TRA PHIÊN BẢN CRYPTOGRAPHY ====="
python -c "import cryptography; print('Cryptography hiện tại:', cryptography.__version__)" 2>/dev/null

echo ""
read -rp "Bạn có muốn nâng cấp cryptography? (y/n): " choice
case "$choice" in
    [Yy]*)
        echo "Lưu ý: Quá trình nâng cấp có thể mất 20-30 phút (biên dịch mã nguồn Rust)."
        pip install -U Cryptography
        pip install -U PyOpenSSL
        ;;
    *)
        echo "Bỏ qua nâng cấp cryptography."
        ;;
esac

# 3. Kiểm tra và in ra thông tin phiên bản
clear
echo "===== THÔNG TIN HỆ THỐNG HIỆN TẠI ====="
python --version
pip --version
python -c "import cryptography; print('Cryptography:', cryptography.__version__)" 2>/dev/null

echo "=================================================="
echo "Cài đặt modules hoàn tất! Tạo bởi HoangPC"
echo "Donate qua Momo: 0865385209"
echo "=================================================="
