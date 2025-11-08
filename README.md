# Ansible EDA Local Test Environment

Lightweight local environment to run an Ansible EDA rulebook and a Vault server for integration testing.

## Files
- [docker-compose.yml](docker-compose.yml) — Compose definition that starts the [`ansible-server`](docker-compose.yml) and [`vault`](docker-compose.yml) services.
- [Dockerfile](Dockerfile) — Image for the Ansible EDA runtime used by [`ansible-server`](docker-compose.yml).
- [inventory.yml](inventory.yml) — Inventory used by the rulebook to target `localhost`.
- [test-rulebook.yml](test-rulebook.yml) — Rulebook containing the `[`splunk_webhook_listener`](test-rulebook.yml)` source and the [`react_to_webhook`](test-rulebook.yml) rule.
- [fix_test.yml](fix_test.yml) — Playbook named [`Respond to event`](fix_test.yml) run by the rulebook; it also rotates a Vault KV secret.

## Quick start
Build and start services:
```sh
docker compose up --build
```

Run in background:
```sh
docker compose up --build -d
```

Stop and remove:
```sh
docker compose down --volumes --remove-orphans
```

## Test the webhook
Send a JSON event that matches the rulebook condition (`event.payload.message == "run"`). Example:
```sh
curl -X POST http://localhost:5000/ \
  -H "Content-Type: application/json" \
  -H "Authorization: Token supersecret123" \
  -d '{"payload":{"message":"run"}}'
```
This hits the webhook source defined in [`test-rulebook.yml`](test-rulebook.yml) and triggers the playbook [`fix_test.yml`](fix_test.yml).

## Vault notes
- Vault is exposed at `http://localhost:8200` by the [`vault`](docker-compose.yml) service.
- The compose file sets `VAULT_ADDR` and `VAULT_TOKEN` in the [`ansible-server`](docker-compose.yml) environment so the playbook in [`fix_test.yml`](fix_test.yml) can talk to Vault.

## Troubleshooting
- Inspect logs: `docker compose logs -f ansible-server`
- Confirm services: `docker compose ps`
- Verify environment variables inside the container if Vault calls fail.


