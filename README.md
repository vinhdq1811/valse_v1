## Tài khoản test

Tất cả tài khoản test seed từ `db/seeds.rb` dùng chung mật khẩu: **`password123`**

Đăng nhập tại: `http://localhost:3000/session/new`

| Email | Họ tên | Vai trò |
|---|---|---|
| `superadmin@valse.test` | Super Admin | superadmin |
| `admin@valse.test` | Quản trị viên | admin |
| `teacher@valse.test` | Nguyễn Thu Hà | teacher (giảng viên) |
| `teacher2@valse.test` | Trần Minh Quân | teacher (giảng viên) |
| `student@valse.test` | Học viên demo | student (học viên) |
| `student2@valse.test` | Lê Gia Bảo | student (học viên) |

Ghi chú:

- Vào trang quản trị tại `http://localhost:3000/admin` (chỉ dành cho superadmin/admin).
- Sau khi sửa `db/seeds.rb`, chạy lại seed trong container: `docker compose exec web bin/rails db:seed`
