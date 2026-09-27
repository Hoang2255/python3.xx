# Termux Python Downgrader

Script Bash tự động hạ cấp và thiết lập môi trường Python chuẩn, ổn định trên Termux (Android). Giải pháp tối ưu giúp khắc phục triệt để các lỗi thiếu Pip, lỗi biên dịch thư viện và xung đột gói khi sử dụng các công cụ Python trên Android.

---

## 🚀 Cài đặt (Installations)

Chi tiết về hướng dẫn cài đặt và cách sử dụng script, vui lòng tham khảo tại:  
👉 [Hướng dẫn cài đặt chi tiết trên GitHub](https://github.com/Hoang2255/install-pip/blob/main/README.md)

---

## 🎯 Tác dụng

- **Hạ cấp và quản lý phiên bản Python linh hoạt:**
  - Hỗ trợ hạ cấp an toàn về **Python 3.12.12** hoặc **Python 3.13.13** tùy theo nhu cầu tương thích của các tool/bot.
  - Hỗ trợ cài đặt độc lập **Python 3.11** (qua `tur-repo`) chạy song song với các phiên bản Python khác.
- **Khắc phục triệt để lỗi môi trường Termux:**
  - Sửa lỗi thiếu hoặc hỏng công cụ quản lý gói `pip`.
  - Giải quyết hoàn toàn lỗi build wheels của các gói nhị phân phức tạp (đặc biệt là `cryptography` và `pyOpenSSL`) trên hệ điều hành Android/Termux.
- **Cung cấp các chế độ triển khai tiện lợi:**
  - **Bản Full:** Tự động hạ cấp Python, thiết lập Pip, cài đặt Cryptography và tự động cài sẵn các module phổ biến (`requests`, `bs4`, `pillow`, `pystyle`, `pycryptodome`, `colorama`, `httpx`, `urllib3`, `pyOpenSSL`).
  - **Bản Lite:** Tinh gọn tối đa, chỉ hạ cấp Python và thiết lập môi trường cốt lõi, không cài thêm module bên thứ ba để tiết kiệm tài nguyên và bộ nhớ.
- **Bảo vệ môi trường sau cài đặt:**
  - Tự động kích hoạt cơ chế khóa phiên bản, ngăn chặn Termux tự động cập nhật đè phiên bản mới khi người dùng thực hiện cập nhật toàn hệ thống.

---

## 🌟 Ưu điểm

- **Tối ưu hóa thời gian (Không cần biên dịch Rust):**  
  Tích hợp sẵn các gói `.deb` của `cryptography` được biên dịch sẵn (pre-built) chuẩn theo từng kiến trúc CPU. Người dùng không cần cài đặt Rust/Cargo và tránh việc mất 20–30 phút biên dịch mã nguồn thủ công, hạn chế tối đa nguy cơ nóng máy hoặc sập ứng dụng giữa chừng.
- **Hỗ trợ đa kiến trúc CPU:**  
  Tương thích hoàn hảo với cả kiến trúc 64-bit (`aarch64`) lẫn 32-bit (`armv7l`, `arm`, `armv8l`).
- **Tự động hóa hoàn toàn & thông minh:**  
  Tự nhận diện cấu trúc phần cứng của máy, tự yêu cầu cấp quyền bộ nhớ (`termux-setup-storage`), tự sửa chữa các gói hỏng (`apt --fix-broken install`) và tự động dọn dẹp các tệp cài đặt `.deb` tạm thời ngay sau khi hoàn tất.
- **Ổn định lâu dài:**  
  Cơ chế `apt-mark hold` đảm bảo môi trường Python hoạt động bền bỉ, không bị lỗi tương thích sau các lần chạy lệnh `pkg upgrade`.
- **Giao diện thân thiện & trực quan:**  
  Menu lựa chọn rõ ràng, có vòng lặp kiểm tra chống nhập sai và in ra bảng trạng thái các phiên bản (`Python`, `Pip`, `Cryptography`, `pyOpenSSL`) trực quan, dễ theo dõi.

---

## ⚙️ Nguyên lí hoạt động

Script vận hành theo một quy trình tự động, chặt chẽ gồm các bước:

1. **Nhận diện phần cứng thiết bị:**  
   Sử dụng lệnh `uname -m` để kiểm tra kiến trúc CPU (`aarch64` hoặc `armv7l`/`arm`). Nếu kiến trúc không được hỗ trợ, script sẽ dừng lại để đảm bảo an toàn cho hệ thống.

2. **Dọn dẹp và chuẩn bị môi trường:**  
   - Yêu cầu cấp quyền truy cập bộ nhớ thiết bị (`termux-setup-storage`).
   - Tự động sửa chữa các gói lỗi còn tồn đọng trong hệ thống (`apt --fix-broken install`, `apt autoremove`).
   - Cập nhật danh sách kho lưu trữ và các gói cơ sở cần thiết thông qua `apt update` & `apt full-upgrade`.

3. **Tải và cài đặt gói Python pre-built:**  
   Xác định URL và tải trực tiếp tệp cài đặt nhị phân `.deb` của phiên bản Python được chọn (Python 3.12 hoặc 3.13) tương thích với kiến trúc CPU hiện tại, sau đó tiến hành cài đặt vào hệ điều hành bằng công cụ `dpkg`.

4. **Khởi tạo Pip và tối ưu Cryptography / pyOpenSSL:**  
   - Tải và chạy script khởi tạo `pip` tương thích trực tiếp với phiên bản Python vừa hạ cấp.
   - Cài đặt gói `.deb` `cryptography` đã biên dịch sẵn tương ứng với phiên bản Python và kiến trúc CPU mà không mất thời gian biên dịch Rust.
   - Cài đặt thư viện `pyOpenSSL` phù hợp qua Pip mà không phát sinh xung đột phụ thuộc (`--no-deps`).

5. **Cài đặt thư viện bổ trợ (đối với bản Full):**  
   Triển khai cài đặt danh sách các thư viện phổ biến phục vụ chạy bot/tool tự động thông qua `pip`.

6. **Khóa phiên bản và dọn dẹp hệ thống:**  
   - Chạy lệnh `apt-mark hold python` nhằm thông báo cho trình quản lý gói của Termux không tự ý nâng cấp đè gói Python.
   - Xóa bỏ các tệp tin `.deb` đã tải về máy để giải phóng dung lượng bộ nhớ.
   - Truy vấn và xuất bảng thông tin chi tiết về phiên bản các gói phần mềm chính đã cài đặt để người dùng kiểm tra trực quan.
