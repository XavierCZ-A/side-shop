# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/setup          # Initial setup: install gems, prepare databases, optionally start server
bin/dev            # Start dev server (Rails + esbuild watch + Tailwind watch via Foreman)
bin/ci             # Full CI: RuboCop, Brakeman, tests, seed check
bin/rubocop        # Ruby style linting (rubocop-rails-omakase)
bin/brakeman       # Security vulnerability scan
bin/rspec          # Run RSpec test suite
bin/rspec spec/models/product_spec.rb  # Run a single spec file
```

## Architecture

**side-shop** is a multi-tenant e-commerce SaaS. Each user owns a `Store`, accessed via subdomain (e.g., `mystore.sideshop.com`). The `StoreSubdomain` constraint in `config/routes.rb` routes subdomain requests to the store-facing controllers; everything else goes to the admin/auth flow.

### Key domain models
- `User` — account owner, has `has_secure_password`, Stripe payment customer via the `pay` gem
- `Store` — belongs to User; the public-facing shop with products, social links, logo/banner images
- `Product` — belongs to Store; has price, active flag, image attachments processed asynchronously by `GenerateImageVariantsJob`
- `Cart` / `LineItem` — per-store shopping cart
- `Order` / `OrderItem` — completed purchases

### Authentication
Custom session-based auth (no Devise). `has_secure_password` on `User`. Session tokens stored in the `sessions` table. Auth helpers live in `AuthenticationHelpers` concern.

### Subscriptions & Billing
Stripe via the `pay` gem. Two `PricingPlan` tiers: Basico (free) and Negocio ($99/mo). Trial tracked via `trial_ends_at` on `User`. Admin billing routes at `/admin/subscriptions` and `/admin/billing`.

### Frontend stack
- **Hotwire**: Turbo for navigation/forms, Stimulus for interactivity
- **CSS**: Tailwind CSS 4.x, built by the `build:css:watch` npm script
- **JS**: esbuild bundling; Stimulus controllers in `app/javascript/controllers/`
- **UI components**: ViewComponent (`app/components/`) for reusable elements (alerts, banners, buttons, cards, modals, etc.)

### Background jobs
GoodJob (v4) handles async jobs and cron. Notable jobs:
- `GenerateImageVariantsJob` — processes product image variants after upload
- `CleanupAbandonedCartsJob` — cron every 2 minutes

### Databases
- **Primary**: PostgreSQL (`side_shopy_development`)
- **Cache / Cable / Queue**: SQLite via `solid_cache` / `solid_cable` (dev); PostgreSQL in production

### Notable patterns
- N+1 detection in development via the Bullet gem — keep an eye on its logs
- `annotate` gem adds schema comments to model files automatically
- Product images use Active Storage with async variant generation; don't assume variants exist synchronously
