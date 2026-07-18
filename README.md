# Armory Depot

A marketplace where users buy and sell prop/replica weapon listings using fake in-app currency.

## Stack

- `backend/` — Ruby on Rails 8 API (PostgreSQL)
- `frontend/` — React + TypeScript (Vite)

## Prerequisites

- Ruby 3.3.5 (managed via [rbenv](https://github.com/rbenv/rbenv))
- Node 20 (managed via [nvm](https://github.com/nvm-sh/nvm))
- PostgreSQL 16 running locally (`brew services start postgresql@16`)

## Backend setup

```bash
cd backend
bundle install
bin/rails db:create db:migrate
bin/rails server -p 3000
```

API is served at `http://localhost:3000/api/v1`. Health check: `http://localhost:3000/up`.

## Frontend setup

```bash
cd frontend
npm install
cp .env.example .env   # points VITE_API_BASE_URL at the backend
npm run dev
```

App is served at `http://localhost:5173`.

## Data model

- `User` — has a `fake_currency_balance` (starts at 1000)
- `Listing` — a weapon listing posted by a seller (`User`), with `price` and `status` (`active` / `sold` / `removed`)
- `Order` — created when a buyer (`User`) purchases a `Listing`; transfers `fake_currency_balance` from buyer to seller and marks the listing `sold`

## API

| Method | Path                                    | Description          |
| ------ | ---------------------------------------- | --------------------- |
| GET    | `/api/v1/users`                          | List users             |
| POST   | `/api/v1/users`                          | Create a user           |
| GET    | `/api/v1/listings`                       | List active listings   |
| POST   | `/api/v1/listings`                       | Create a listing        |
| PATCH  | `/api/v1/listings/:id`                   | Update a listing        |
| DELETE | `/api/v1/listings/:id`                   | Remove a listing        |
| POST   | `/api/v1/listings/:listing_id/orders`    | Buy a listing            |

No authentication is wired up yet — `buyer_id`/`seller_id` are passed directly. Add real auth before this goes anywhere near production.
