
db-start:
	docker compose up -d

db-stop:
	docker compose down

db-remove:
	docker compose down -v

db-restart:
	docker compose restart

db-logs:
	docker compose logs -f


db-prepare:
	bin/rails db:create
	bin/rails db:migrate
	bin/rails db:seed


# testing

test:
	bin/rails test

test-system:
	DRIVER=chrome bin/rails test:system
