# Social App — منصة تواصل اجتماعي متكاملة

منصة تجمع بين الفيديوهات القصيرة، الغرف الصوتية/المرئية، التعارف الجغرافي، والمراسلة الفورية.

## البنية
- `apps/mobile` — تطبيق Flutter (Android & iOS)
- `apps/admin_dashboard` — لوحة تحكم Flutter Web
- `services/backend` — Node.js + Express + MongoDB
- `infra` — Docker, Nginx, CI/CD

## التشغيل السريع
```bash
cp .env.example .env
docker-compose up -d