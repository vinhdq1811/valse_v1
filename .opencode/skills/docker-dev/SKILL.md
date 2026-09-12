---
name: docker-dev
description: Dự án valse_v1 (Rails 8) dev hoàn toàn qua Docker Compose — dùng skill này khi cần chạy server, rails console, rake task, test, hoặc kiểm tra trang web. KHÔNG có Ruby trên máy host (Windows), không chạy bin/rails trực tiếp.
---

# Dev qua Docker

Dự án này được phát triển **hoàn toàn qua Docker Compose**. Máy host (Windows) **không cài Ruby** — mọi lệnh Rails phải chạy trong container.

## Các container

| Service | Container | Ghi chú |
|---|---|---|
| `web` | `valse_v1_web` | Rails server, mount source `.:/rails`, port **3000** |
| `db` | `valse_v1_db` | PostgreSQL 17, không expose port ra host |

## Lệnh thường dùng

```powershell
docker compose up -d                 # khởi động db + web
docker compose ps                    # xem trạng thái
docker compose logs -f web           # xem log server
docker compose exec web bin/rails console          # rails console
docker compose exec web bin/rails routes           # xem routes
docker compose exec web bin/rails db:migrate       # migrate
docker compose restart web                         # restart sau khi đổi Dockerfile/boot
docker compose down                                # dừng tất cả
```

## Kiểm tra trang web

Server chạy tại `http://127.0.0.1:3000` (được map ra host). Ví dụ test bằng PowerShell:

```powershell
Invoke-WebRequest -Uri "http://127.0.0.1:3000/course-detail" -UseBasicParsing
```

## Lưu ý quan trọng

- Source code được **volume-mount trực tiếp** vào container (`.:/rails`) nên sửa file trên host là server Rails dev **tự reload**, không cần restart container.
- KHÔNG chạy `bin\rails` / `ruby` trực tiếp trên máy host — sẽ lỗi "file not found".
- Nếu container chưa chạy, phải `docker compose up -d` trước khi test bất kỳ trang nào.
- DB dev: `valse_v1_development`, user/pass `postgres/postgres`, host `db` (từ trong container).
