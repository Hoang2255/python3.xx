# Termux Python Downgrader Script

Script Bash tự động hạ cấp và thiết lập môi trường Python chuẩn trên Termux (Android). Hỗ trợ hạ cấp nhanh về **Python 3.12.12** hoặc **Python 3.13.13**, tự động cấu hình Pip, fix lỗi build modules và khóa phiên bản tránh bị ghi đè khi update hệ thống.

- **Tác giả:** HoangPC
- **Momo Donate:** `0865385209`

---

## 🌟 Tính năng nổi bật

- **Hỗ trợ 2 phiên bản Python ổn định:**
  - `Python 3.12.12` (Phiên bản tương thích tốt nhất cho hầu hết các tool/bot hiện nay)
  - `Python 3.13.13`
- **Hỗ trợ đa kiến trúc CPU:**
  - `aarch64` (ARM 64-bit)
  - `armv7l` / `arm` (ARM 32-bit)
- **Tự động tối ưu môi trường Termux:**
  - Tự động cập nhật kho package: `pkg update` & `pkg upgrade`.
  - Cài đặt sẵn các package hệ thống cần thiết: `mandoc`, `perl`, `python-pip`, `termux-services`, `php`, `wget`, `git`, `rust`, `libjpeg-turbo`, `cargo-termux`.
  - Khóa phiên bản (`apt-mark hold python`) giúp không bị Termux tự động nâng cấp đè phiên bản mới khi chạy `pkg upgrade`.
- **Cài đặt sẵn các thư viện Python phổ biến:**
  - `pillow`, `bs4`, `requests`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`, `pyOpenSSL`.
- **Tối ưu Cryptography & pyOpenSSL:**
  - Tích hợp sẵn gói cryptography `.deb` được build sẵn tối ưu cho từng kiến trúc (46.0.3 cho Python 3.12 và 48.0.1 cho Python 3.13), không mất thời gian build Rust (tiết kiệm 20-30 phút).
  - Tự động cài đặt pyOpenSSL tương thích và dọn dẹp các file `.deb` tạm sau khi hoàn tất.

---

## 📋 Yêu cầu hệ thống

- Ứng dụng **Termux** (Khuyến nghị cài bản từ [F-Droid](https://f-droid.org/packages/com.termux/) hoặc [GitHub Termux](https://github.com/termux/termux-app/releases), **không** sử dụng bản cũ trên Google Play).
- Kiến trúc máy: `aarch64` hoặc `armv7l` / `arm`.
- Kết nối Internet ổn định.
- Dung lượng bộ nhớ trống tối thiểu: **500MB - 1GB**.

---

## 🚀 Hướng dẫn cài đặt và sử dụng

> [!IMPORTANT]
> **Lưu ý nguyên nhân lỗi trước đây:** Đường dẫn cũ trỏ nhầm vào kho `install-pip` (trả về lỗi 404 Not Found), khiến lệnh `curl` không tải được file về máy và dẫn đến lỗi `No such file or directory` khi chạy `./downgrade_python.sh`. Đường dẫn chính xác nằm ở kho `python3.xx` như hướng dẫn dưới đây.

---

### Cách 1: Chạy nhanh bằng 1 lệnh duy nhất (Khuyến nghị ⭐)

Mở Termux và dán toàn bộ dòng lệnh sau rồi nhấn **Enter**:

```bash
pkg update -y && pkg install -y curl && curl -fsSL -O https://raw.githubusercontent.com/Hoang2255/python3.xx/main/downgrade_python.sh && chmod +x downgrade_python.sh && bash downgrade_python.sh
```

---

### Cách 2: Cài đặt từng bước thủ công (Dễ kiểm soát)

#### Bước 1: Cập nhật Termux và cài đặt `curl`
Đảm bảo Termux đã có sẵn tiện ích `curl`:
```bash
pkg update -y && pkg install -y curl
```

#### Bước 2: Tải script hạ cấp Python
Tải trực tiếp script từ kho lưu trữ chính xác (`Hoang2255/python3.xx`):
```bash
curl -fsSL -O https://raw.githubusercontent.com/Hoang2255/python3.xx/main/downgrade_python.sh
```

#### Bước 3: Cấp quyền thực thi
```bash
chmod +x downgrade_python.sh
```

#### Bước 4: Khởi chạy script
```bash
./downgrade_python.sh
```
*(Nếu gặp lỗi phân quyền hoặc lỗi định dạng dòng, bạn có thể chạy bằng lệnh: `bash downgrade_python.sh`)*

---

### Cách 3: Phương án dự phòng (Khi `curl` gặp sự cố)

#### Dùng `wget` thay cho `curl`:
```bash
pkg install -y wget && wget https://raw.githubusercontent.com/Hoang2255/python3.xx/main/downgrade_python.sh -O downgrade_python.sh && chmod +x downgrade_python.sh && bash downgrade_python.sh
```

#### Hoặc Clone trực tiếp kho GitHub:
```bash
pkg install -y git && git clone https://github.com/Hoang2255/python3.xx.git && cd python3.xx && chmod +x downgrade_python.sh && bash downgrade_python.sh
```

---

## 📂 Các Script Đã Phân Tách (Modular Scripts)

Nếu bạn muốn chạy từng bước riêng biệt thay vì chạy toàn bộ trong một file duy nhất, bạn có thể sử dụng 4 script đã được bóc tách:

1. **`setup_and_select.sh`**:
   - Kiểm tra kiến trúc CPU máy (`aarch64` hoặc `armv7l/arm/armv8l`).
   - Hiển thị menu lựa chọn phiên bản Python (3.12 hoặc 3.13).
   - Cập nhật repository và cài đặt các package cơ bản hệ thống.
   - Tự động gọi script hạ cấp Python tương ứng và hoàn tất bằng `install_modules.sh`.

2. **`downgrade_python3.12.sh`**:
   - Tự động kiểm tra kiến trúc máy.
   - Tải và cài đặt gói `.deb` Python 3.12.12 tương ứng với kiến trúc.
   - Cài đặt pip, gói cryptography tương thích (46.0.3), pyOpenSSL và khóa phiên bản (`apt-mark hold`).

3. **`downgrade_python3.13.sh`**:
   - Tự động kiểm tra kiến trúc máy.
   - Tải và cài đặt gói `.deb` Python 3.13.13 tương ứng với kiến trúc.
   - Cài đặt pip, gói cryptography tương thích (48.0.1), pyOpenSSL và khóa phiên bản (`apt-mark hold`).

4. **`install_modules.sh`**:
   - Cài đặt các module Python phổ biến: `pillow`, `bs4`, `requests`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`.
   - Kiểm tra và hiển thị đầy đủ thông tin phiên bản hệ thống trực quan, đẹp mắt (`Python`, `Pip`, `Cryptography`, `pyOpenSSL`).

---

## 🖥 Giao diện Menu lựa chọn

Khi khởi chạy thành công, script sẽ tự động nhận diện CPU và hiển thị menu:

```text
===== CHỌN PHIÊN BẢN PYTHON CẦN HẠ CẤP =====
1) Python 3.12.12
2) Python 3.13.13
0) Thoát
Nhập lựa chọn của bạn: 
```

- **Nhập `1`:** Hạ cấp về **Python 3.12.12** *(Khuyến nghị nếu bạn dùng các tool chạy Requests, PyStyle, PyCryptodome)*.
- **Nhập `2`:** Hạ cấp về **Python 3.13.13**.
- **Nhập `0`:** Hủy và thoát chương trình.

---

## ⚙️ Quy trình hoạt động của Script

1. **Kiểm tra kiến trúc CPU**: Xác định thiết bị là `aarch64` hay `armv7l|arm`. Nếu thiết bị không thuộc 2 kiến trúc này, script sẽ dừng an toàn để tránh xung đột hệ thống.
2. **Cập nhật hệ thống**: Cập nhật danh sách package và cài đặt các gói phụ thuộc bắt buộc.
3. **Tải & cài đặt gói Python .deb**: Tải gói `.deb` tương thích với phiên bản và kiến trúc đã chọn, cài đặt thông qua `dpkg`.
4. **Cài đặt Pip & Cryptography**: Cấu hình môi trường Pip chuẩn, cài đặt gói deb cryptography tối ưu và pyOpenSSL tương ứng.
5. **Cài đặt Modules**: Tự động cài các thư viện Python thông dụng: `pillow`, `bs4`, `requests`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`.
6. **Khóa phiên bản & Dọn dẹp**: Chạy `apt-mark hold python` để bảo vệ phiên bản, tự động xóa các file `.deb` tạm và in thông tin kiểm tra cuối cùng.

---

## 🛠 Xử lý lỗi thường gặp (Troubleshooting)

| Lỗi gặp phải | Nguyên nhân | Cách khắc phục |
| :--- | :--- | :--- |
| **`No such file or directory`** khi chạy `./downgrade_python.sh` | File chưa được tải về do sai link cũ (404) hoặc ngắt mạng | Dùng link mới từ repo `python3.xx` (Xem [Cách 1](#cách-1-chạy-nhanh-bằng-1-lệnh-duy-nhất-khuyến-nghị-)) và kiểm tra lại bằng lệnh `ls -la downgrade_python.sh`. |
| **`curl: command not found`** | Termux chưa cài đặt gói `curl` | Chạy lệnh: `pkg update && pkg install -y curl`. |
| **`Permission denied`** | File chưa được cấp quyền thực thi | Chạy lệnh: `chmod +x downgrade_python.sh` hoặc khởi chạy trực tiếp bằng `bash downgrade_python.sh`. |
| **`$'\r': command not found`** | File script bị dính ký tự xuống dòng Windows (CRLF) khi tải qua PC | Chạy lệnh sửa ký tự: `sed -i -e 's/\r$//' downgrade_python.sh` rồi chạy lại `bash downgrade_python.sh`. |
| **Termux bị văng / dừng giữa chừng khi cài** | Android tối ưu pin khiến Termux bị sleep | Kéo thanh thông báo trên cùng của điện thoại xuống, tại thông báo của Termux bấm **Acquire Wakelock** (hoặc gõ lệnh `termux-wake-lock`). |

---

## ⚠️ Lưu ý quan trọng

- Không tắt Termux hoặc ngắt kết nối mạng giữa chừng khi `dpkg` đang giải nén gói tin.
- Các file `.deb` tải về sẽ tự động được xóa sau khi cài đặt xong để giải phóng bộ nhớ cho thiết bị.

---

## ☕ Ủng hộ tác giả (Donate)

Nếu script hữu ích cho công việc và học tập của bạn, bạn có thể gửi tặng một ly cà phê ủng hộ tác giả:
- **Tác giả:** HoangPC
- **Momo:** `0865385209`
