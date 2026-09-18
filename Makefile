.PHONY: help install dev build up down logs

help:
	@echo "الأوامر المتاحة:"
	@echo "  make install   - تثبيت الحزم لكل الأجزاء"
	@echo "  make dev       - تشغيل بيئة التطوير"
	@echo "  make up        - تشغيل Docker"
	@echo "  make down      - إيقاف Docker"
	@echo "  make logs      - عرض السجلات"

install:
	cd services/backend && npm install
	cd apps/mobile && flutter pub get
	cd apps/admin_dashboard && flutter pub get

dev:
	docker-compose up -d mongo redis
	cd services/backend && npm run dev

up:
	docker-compose up -d

down:
	docker-compose down

logs:
	docker-compose logs -f