 Plan: Generar ANALYSIS.md con auditoría exhaustiva de side-shop

 Contexto

 El usuario quiere una revisión completa del estado actual de la aplicación Rails side-shop (e-commerce SaaS multi-tenant) para identificar puntos de mejora,
 refactors, malas prácticas, oportunidades de background jobs y caching. Tras explorar la app con 3 agentes en paralelo (capa de modelos/controllers/services,
 capa de vistas/components/frontend, e infraestructura/jobs/config/security), tengo una vista exhaustiva del estado.

 El entregable es un único documento markdown en la raíz del proyecto: ANALYSIS.md. Cada hallazgo debe seguir esta estructura:
 1. Problema — qué está mal y dónde se encuentra (file_path:line)
 2. Por qué es problema — razón técnica del refactor
 3. Solución — pista o snippet de código

 Los hallazgos se ordenan por severidad: 🔴 CRÍTICO → 🟠 ALTO → 🟡 MEDIO → 🟢 MEJORAS.

 ---
 Archivo a crear

 /home/xavier/side-shop/ANALYSIS.md — único archivo nuevo.

 Estructura del documento

 # Análisis técnico — side-shop
 > Fecha: 2026-05-05
 > Alcance: revisión de modelos, controllers, vistas, jobs, infra, security, caching

 ## Tabla de contenidos
 ## Resumen ejecutivo (tabla con conteo por severidad)

 ## 🔴 CRÍTICO  (~10 items)
 ## 🟠 ALTO     (~12 items)
 ## 🟡 MEDIO    (~12 items)
 ## 🟢 MEJORAS / OPORTUNIDADES  (background jobs, caching, refactors)

 ## Apéndice: roadmap sugerido por sprints

 Cada hallazgo lleva el formato:

 ### [N] Título corto del problema
 **Ubicación:** `path/to/file.rb:LL`
 **Problema:** Descripción del bug/mala práctica.
 **Por qué refactorizar:** Razón técnica (perf, seguridad, mantenibilidad, estándar Rails).
 **Solución:**
 ```ruby
 # Código actual (si aplica)
 ...
 # Código sugerido
 ...

 ---

 ## Hallazgos a incluir

 ### 🔴 CRÍTICO

 1. **`stores.slug` sin índice único en DB** — `db/schema.rb` (tabla stores). Cada request a un subdomain hace `Store.find_by!(slug:)` sin índice. Solución:
 migración `add_index :stores, :slug, unique: true`.

 2. **Tabla `orders` sin foreign keys ni índices** — `db/migrate/20260222042044_create_orders.rb`. No hay relación con `store` ni `user`. Multi-tenancy roto.
 Solución: migración añadiendo `add_reference :orders, :store, foreign_key: true, index: true` + `add_reference :orders, :user`.

 3. **Modelo `Order` esquelético sin validaciones** — `app/models/order.rb:1-5`. Sin enum de status, sin `belongs_to`, sin validaciones de presence en
 `total_cents`, `shipping_*`. Solución: snippet completo con `belongs_to :store`, `belongs_to :user`, `enum :status, { pending: 0, paid: 1, shipped: 2,
 cancelled: 3 }`, validaciones.

 4. **`Cart` sin validaciones** — `app/models/cart.rb`. `store_id` es NOT NULL en DB pero sin `validates :store_id, presence: true`. Permite carts huérfanos a
 nivel ActiveRecord. Solución: añadir `belongs_to :store` (que valida automáticamente) y validaciones.

 5. **`LineItem` sin validar `quantity > 0`** — `app/models/line_item.rb:18-24`. Permite cantidades negativas o cero. Solución: `validates :quantity, presence:
 true, numericality: { greater_than: 0 }`.

 6. **N+1 en `Cart#total_price`** — `app/models/cart.rb:26-28`. Aunque usa `joins`, el método se invoca también en views con cada `item.product.price`. Solución:
  usar `.includes(:product)` o calcular en SQL puro con un único query (`sum('products.price * line_items.quantity')` ya está bien, pero hay que asegurar que el
 preload se haga en el controller que usa `total_price` + iteración de items).

 7. **CSP (Content Security Policy) deshabilitado** — `config/initializers/content_security_policy.rb:1-29` todo comentado. App vulnerable a XSS/clickjacking.
 Solución: snippet con CSP mínimo (`default_src :self`, `style_src :self :unsafe_inline` para Tailwind, `img_src :self https: data:`, `script_src :self`).

 8. **`config.force_ssl` deshabilitado en producción** — `config/environments/production.rb:31`. Solución: descomentar + asegurar redirect.

 9. **Cache store en producción no configurado** — `config/environments/production.rb:49-50`. `perform_caching = true` activo pero sin `cache_store` → cache
 silenciosamente no persiste. Solución: `config.cache_store = :solid_cache_store` (ya está en gemfile) o `:mem_cache_store`.

 10. **`GenerateImageVariantsJob` sin error handling ni idempotencia** — `app/jobs/generate_image_variants_job.rb:1-10`. Falla silenciosamente si la imagen no
 existe; regenera variantes en cada ejecución. Solución: `discard_on ActiveStorage::FileNotFoundError`, `retry_on Errno::ECONNREFUSED, wait:
 :polynomially_longer`, check `.processed?` antes de invocar `.processed`.

 ### 🟠 ALTO

 11. **Capa de servicios prácticamente inexistente** — `app/services/` solo tiene `storefront/sample_products.rb`. La lógica de Stripe checkout vive en
 `app/controllers/admin/subscriptions_controller.rb:8-29`. Solución: extraer `Subscriptions::CreateCheckoutService`, `Orders::CreateFromCartService`,
 `Onboarding::CompleteOnboardingService`. Pista de estructura de carpeta.

 12. **`Onboarding#generate_slug` hace N queries en loop** — `app/models/onboarding.rb:74-97` línea 91 (`Store.exists?(slug:)` dentro de un loop). Solución:
 pre-cargar slugs candidatos en una sola query `Store.where(slug: candidates).pluck(:slug)` o usar índice único + retry on `RecordNotUnique`.

 13. **Sin paginación en lista de productos admin** — `app/controllers/admin/dashboards_controller.rb:10` (`@store.products...` sin `limit`/`page`). Carga todos
 a memoria. Solución: añadir `kaminari` o `pagy` y `.page(params[:page]).per(20)`.

 14. **Sin rate limiting en login (sólo en uno de los dos endpoints)** — `app/controllers/authentication/sessions_controller.rb:6` tiene `rate_limit to: 10` ✅,
 pero password reset no tiene. Solución: añadir `rate_limit` a `passwords_controller`.

 15. **Sin sistema de autorización formal** — toda la app depende de `current_user.store.products.find(...)`. Solución: introducir `Pundit` con policies por
 modelo (`ProductPolicy`, `StorePolicy`); incluir snippet básico.

 16. **Webhooks de Stripe sin handlers custom** — `config/routes.rb:4` monta `Pay::Engine` que recibe webhooks, pero no hay subscriptores a eventos
 `customer.subscription.deleted`, `invoice.payment_failed`, etc. Solución: snippet de `Pay::Webhooks.delegator.subscribe(...)` en initializer.

 17. **Duplicación admin/storefront `_product_card`** — `app/views/admin/products/_product_card.html.erb` (95 líneas) vs
 `app/views/storefronts/_product_card.html.erb` (125 líneas). Solución: crear `Products::CardComponent` con slots `:actions` para customizar botones por
 contexto.

 18. **`accordion_controller.js` con 419 líneas** — `app/javascript/controllers/accordion_controller.js`. Demasiada complejidad para abrir/cerrar. Solución: usar
  `data-state` + CSS `[data-state=open]` transitions; mostrar diff conceptual del controller simplificado a ~150 líneas.

 19. **`VIBE_TOKENS` duplicado en Ruby y JS** — `app/helpers/storefronts_helper.rb:20-63` y `app/javascript/controllers/design_editor_controller.js:3-34`. Riesgo
  de desincronización. Solución: extraer a `config/storefront_design_tokens.yml`, generar JSON consumido por JS via `<script type="application/json">` o asset.

 20. **Tests críticos vacíos (`pending`)** — `spec/models/order_spec.rb`, `spec/jobs/generate_image_variants_job_spec.rb`. Solución: ejemplos mínimos de specs
 (factory, validaciones, scope tests).

 21. **Sin tests de aislamiento multi-tenant** — no se valida que `user A` no acceda al `store` de `user B`. Solución: snippet de request spec que valida
 404/forbidden cross-tenant.

 22. **`StoreScoped` renderiza `404.html` estático** — `app/controllers/concerns/store_scoped.rb`. Solución: usar `raise ActionController::RoutingError` o
 `render template: "errors/not_found", status: :not_found, layout: "application"`.

 ### 🟡 MEDIO

 23. **Validación de email sin formato** — `app/models/user.rb:24-25`. Permite `test@`. Solución: `validates :email_address, format: { with:
 URI::MailTo::EMAIL_REGEXP }`.

 24. **Validación de password sin requisitos de complejidad** — `app/models/user.rb:25`. Solo length >= 6. Solución: añadir `format` con regex que requiera al
 menos un número y una mayúscula, o usar `password_complexity` gem.

 25. **`Store` sin validaciones de presence en `name`/`slug`** — `app/models/store.rb:40-43`. Solución: `validates :name, :slug, presence: true; validates :slug,
  uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }`.

 26. **`PricingPlan.all` cargado en cada request** — `app/controllers/admin/billing_controller.rb`, `subscriptions_controller.rb`. Solución:
 `Rails.cache.fetch("pricing_plans", expires_in: 1.day) { PricingPlan.all.to_a }`.

 27. **Sin HTTP caching (`fresh_when`/`stale?`) en storefront** — `app/controllers/stores_controller.rb`. Solución: `fresh_when @store, last_modified:
 @store.products.maximum(:updated_at)`.

 28. **Layouts duplicados** — `app/views/layouts/dashboard_layout.html.erb` y `storefront_layout.html.erb` casi idénticos. Solución: extraer `_head.html.erb` y
 `_body_meta.html.erb`, dejar diferencia mínima.

 29. **Lógica de diseño en `StorefrontsHelper`** — `app/helpers/storefronts_helper.rb` (115 líneas). Lógica de generación de CSS variables debería ser un PORO
 (ej. `Storefront::DesignTokens`). Solución: snippet del PORO.

 30. **`display_field_errors` mezcla markup en helper** — `app/helpers/application_helper.rb`. Solución: convertir a `Forms::FieldErrorComponent`.

 31. **Inputs muy repetidos sin componente** — clases Tailwind largas duplicadas 6+ veces en `app/views/admin/products/_form.html.erb`, formularios de
 onboarding, etc. Solución: crear `Forms::InputComponent` con variants y slots.

 32. **Sin timezone configurado** — `config/application.rb` (`config.time_zone` comentado). Solución: `config.time_zone = "America/Lima"` (o región del usuario).

 33. **Mezcla de `params.expect` y `params.require().permit()`** — varios controllers. Solución: estandarizar en `params.expect` (Rails 8.1).

 34. **`CleanupAbandonedCartsJob` sin idempotencia explícita** — `app/jobs/cleanup_abandoned_carts_job.rb:1-13`. Solución: envolver en
 `ActiveRecord::Base.transaction`, usar `find_each(batch_size: 100).destroy_all` para batching.

 ### 🟢 MEJORAS / OPORTUNIDADES

 #### Background jobs nuevos
 - **`OrdersCreateFromCartJob`** — al recibir webhook de Stripe `payment_intent.succeeded`, crear `Order` desde `Cart` en background. Razón: el webhook debe
 responder rápido (Stripe da 10s).
 - **`OrderConfirmationEmailJob`** — enviar email tras crear orden. Razón: SMTP es lento, no bloquear request.
 - **`GenerateProductSlugJob`** — si productos van a tener slugs públicos. Razón: query a DB para uniqueness no debe bloquear save.
 - **`StripeSyncCustomerJob`** — sync de subscription state del webhook a cache local. Razón: evita queries a Stripe API en cada request.
 - **`CartAbandonmentEmailJob`** — antes de eliminar cart abandonado, enviar email recordatorio si tiene email. Razón: recuperación de ventas.

 #### Caching opportunities
 - **Fragment caching en listings de productos** — `app/views/storefronts/_products_section.html.erb` ya usa `cached: true` en collection ✅. Extender a admin
 listings con `cache @products do ... end` con touch en Product → Store.
 - **Russian-doll caching** — Store touches Product, Product touches LineItem; cachear cada nivel.
 - **`Rails.cache.fetch` para `PricingPlan.all`** (ver #26).
 - **HTTP `fresh_when`/`stale?`** en `stores#show`, `products#show` (ver #27).
 - **`low_card_tables` o cache de `Store#vibe`/`hero_layout`** ya que rara vez cambian — usar `Rails.cache.fetch("store/#{id}/design_tokens", ...)`.
 - **Action Cable / Turbo Streams cache** — si hay broadcast a múltiples viewers, cachear el render parcial.

 #### Refactors arquitectónicos
 - Crear `app/services/` con subnamespaces (`orders/`, `subscriptions/`, `onboarding/`).
 - Convertir 5+ partials grandes en ViewComponents (`Products::CardComponent`, `Hero::Component`, `Pricing::PlanComponent`, `Cart::ItemComponent`,
 `Forms::InputComponent`).
 - Centralizar tokens de diseño en YAML compartido Ruby/JS.
 - Adoptar `Pundit` para autorización formal.
 - Implementar checkout completo con orden creation + Stripe Payment Intents (ruta POST `/checkout` que hoy no existe).