# Termux Python Downgrader Script

Script Bash tự động hạ cấp và thiết lập môi trường Python trên Termux (Android). Hỗ trợ hạ cấp nhanh về Python 3.13.13 hoặc các bản cũ hơn hiện đang hỗ trợ, tự động cấu hình pip, fix lỗi build modules và khóa phiên bản tránh bị ghi đè.

- **Tác giả:** HoangPC
- **Momo Donate:** `0865385209`

---

## 🌟 Tính năng nổi bật

- **Hỗ trợ 2 phiên bản Python ổn định:**
  - `Python 3.12.12`
  - `Python 3.13.13`
- **Hỗ trợ đa kiến trúc CPU:**
  - `aarch64` (ARM 64-bit)
  - `armv7l` / `arm` (ARM 32-bit)
- **Tự động tối ưu môi trường Termux:**
  - Tự động cập nhật kho package: `pkg update` & `pkg upgrade`.
  - Cài đặt sẵn các package hệ thống cần thiết: `mandoc`, `perl`, `python-pip`, `termux-services`, `php`, `wget`, `git`, `unzip`, `rust`, `libjpeg-turbo`, `cargo-termux`.
  - Khóa phiên bản (`apt-mark hold python`) giúp không bị tự nâng cấp khi chạy `pkg upgrade`.
- **Cài đặt sẵn các thư viện Python phổ biến:**
  - `pillow`, `bs4`, `requests`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`, `pyOpenSSL`.
- **Quản lý Cryptography:**
  - Kiểm tra phiên bản cryptography sau khi hạ cấp.
  - Tùy chọn nâng cấp lên phiên bản cryptography mới nhất trực tiếp trong script.

---

## 📋 Yêu cầu hệ thống

- Ứng dụng **Termux** (Khuyến nghị bản từ F-Droid hoặc GitHub Termux, không dùng bản Google Play).
- Kiến trúc máy: `aarch64` hoặc `armv7l` / `arm`.
- Kết nối Internet ổn định.

---

## 🚀 Hướng dẫn cài đặt và sử dụng

### Bước 1: Mở Termux và tải script

Nếu đã có script `downgrade_python.sh`, bạn di chuyển vào thư mục chứa script. Hoặc tải trực tiếp bằng lệnh:

```bash
curl -fsSL -O https://raw.githubusercontent.com/Hoang2255/install-pip/main/downgrade_python.sh
```

### Bước 2: Cấp quyền thực thi

```bash
chmod +x downgrade_python.sh
```

### Bước 3: Khởi chạy script

```bash
./downgrade_python.sh
```
*(Hoặc chạy thông qua bash: `bash downgrade_python.sh`)*

---

## 🖥 Giao diện Menu lựa chọn

Khi khởi chạy, script hiển thị menu chọn phiên bản:

```text
===== CHỌN PHIÊN BẢN PYTHON CẦN HẠ CẤP =====
1) Python 3.12.12
2) Python 3.13.13
0) Thoát
Nhập lựa chọn của bạn: 
```

- Nhập `1`: Hạ cấp về Python 3.12.12
- Nhập `2`: Hạ cấp về Python 3.13.13
- Nhập `0`: Hủy và thoát chương trình

---

## ⚙️ Quy trình hoạt động của Script

1. **Kiểm tra kiến trúc CPU**: Xác định thiết bị là `aarch64` hay `armv7l|arm`. Nếu thiết bị không thuộc 2 kiến trúc này, script sẽ dừng để tránh lỗi hỏng môi trường.
2. **Cập nhật hệ thống**: Cập nhật danh sách package và cài đặt các phụ thuộc bắt buộc.
3. **Tải & cài đặt Python .deb**: Tải gói `.deb` tương thích với phiên bản và kiến trúc đã chọn, cài đặt qua `dpkg`.
4. **Cài đặt Pip & fix wheels**: Tải script `install-pip.py`, cấu hình pip chuẩn.
5. **Cài đặt Modules**: Cài đặt các thư viện Python thường dùng trong lập trình bot/tool.
6. **Kiểm tra & Hoàn tất**: Kiểm tra phiên bản Python, Pip, Cryptography và xuất kết quả.

---

## ⚠️ Lưu ý quan trọng

- Nếu chọn nâng cấp `cryptography` lên bản mới nhất bằng `pip install -U cryptography`, quá trình biên dịch từ source code Rust có thể mất từ **20 - 30 phút** tùy thuộc vào cấu hình thiết bị.
- Đảm bảo thiết bị còn đủ dung lượng trống (tối thiểu 500MB - 1GB) trước khi thực hiện.
- Tránh tắt Termux hoặc ngắt kết nối mạng giữa chừng khi `dpkg` đang làm việc.

---

## ☕ Ủng hộ tác giả (Donate)

Nếu script hữu ích cho bạn, bạn có thể ủng hộ tác giả qua Momo:
- Tác giả: HoangPC
- Momo: `0865385209`
