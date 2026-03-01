# performance rules

## database
- no N+1 queries — use JOINs, batch fetching, or DataLoader
- index frequently queried columns
- paginate all list endpoints (cursor-based preferred)

## api
- response time target: <200ms for reads, <500ms for writes
- use caching headers where appropriate
- compress responses (gzip/brotli)

## frontend
- lazy-load routes and heavy components
- optimize images (WebP, appropriate sizing)
- minimize bundle size — tree-shake aggressively
