# Open Grapher

A small utility that fetches [Open Graph](https://ogp.me/) metadata for any URL. Submit a link, and the result appears in real-time once the background job finishes processing.

## How it works

1. You paste a URL into the form
2. A Sidekiq job is enqueued to fetch and parse the page's OG tags
3. The result streams back to the browser via Turbo Streams and replaces the pending spinner

Each browser session maintains its own lookup history. Open an incognito window and you get a clean slate.

## Why Redis

Redis is the single backing store for the entire app. There is no traditional database.

- **Ephemeral storage** — Lookup results are stored in Redis hashes with a 24-hour TTL. There's nothing worth persisting long-term, so a relational database would be unnecessary overhead. Data expires automatically and Redis reclaims the memory.
- **Sidekiq** — Sidekiq requires Redis for its job queue. Since Redis is already a dependency, it made sense to use it as the data store too rather than introducing a second stateful service.
- **ActionCable** — Turbo Streams rely on ActionCable for WebSocket broadcasts. Redis serves as the pub/sub backend, which means all three services (web, Sidekiq, Redis) can communicate through a single shared dependency.

One service handles job queuing, real-time broadcast, and data storage. The architecture stays simple.

## Running locally

```
docker compose up --build
```

This starts three services:

| Service  | Description              |
|----------|--------------------------|
| **web**  | Rails on port 3001       |
| **sidekiq** | Background job worker |
| **redis**   | Redis 7 (Alpine)      |

Visit [localhost:3001](http://localhost:3001) to use the app, and [localhost:3001/sidekiq](http://localhost:3001/sidekiq) for the Sidekiq dashboard.

## Stack

- Ruby 3.4 / Rails 8.1
- Sidekiq + Redis
- Turbo Streams (ActionCable + WebSockets)
- [open_graph_reader](https://github.com/jhass/open_graph_reader) + Faraday
