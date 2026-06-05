dev_first:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file ./secrets/.env.dev up -d --build
prod_first:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file ./secrets/.env.prod up -d --build
dev:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file ./secrets/.env.dev up -d
prod:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file ./secrets/.env.prod up -d
down_dev:
	docker compose -f docker-compose.yml -f docker-compose.dev.yml --env-file ./secrets/.env.dev down
down_prod:
	docker compose -f docker-compose.yml -f docker-compose.prod.yml --env-file ./secrets/.env.prod down