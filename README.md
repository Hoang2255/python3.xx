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
- **Quản lý Cryptography:**
  - Kiểm tra và tích hợp sẵn bản cryptography tương thích.
  - Tùy chọn nâng cấp lên phiên bản cryptography mới nhất trực tiếp trong script.

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
4. **Cài đặt Pip & fix wheels**: Tải script `install-pip.py`, cấu hình môi trường Pip chuẩn.
5. **Cài đặt Modules**: Tự động cài các thư viện Python thông dụng: `pillow`, `bs4`, `requests`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`.
6. **Kiểm tra Cryptography**: Hỏi người dùng có muốn build phiên bản mới nhất hay giữ nguyên bản tối ưu sẵn.
7. **Khóa phiên bản & Hoàn tất**: Chạy `apt-mark hold python` để bảo vệ phiên bản và in thông tin kiểm tra cuối cùng.

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

- Ở bước hỏi **"Bạn có muốn nâng cấp cryptography? (y/n)"**:
  - Khuyến nghị chọn **`n`** (No) để hoàn tất nhanh chóng và sử dụng ngay bản `.deb` đã được build sẵn chuẩn xác.
  - Nếu chọn **`y`** (Yes), thiết bị sẽ biên dịch từ source code Rust; quá trình này có thể tốn từ **20 - 30 phút** và tiêu hao nhiều pin/CPU.
- Không tắt Termux hoặc ngắt kết nối mạng giữa chừng khi `dpkg` đang giải nén gói tin.

---

## ☕ Ủng hộ tác giả (Donate)

Nếu script hữu ích cho công việc và học tập của bạn, bạn có thể gửi tặng một ly cà phê ủng hộ tác giả:
- **Tác giả:** HoangPC
- **Momo:** `0865385209`
