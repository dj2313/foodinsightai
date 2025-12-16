# FoodSight AI — Multi-Agent Architecture

This document describes the backend architecture to power the existing FoodSight AI UI. It aligns the modular feature overview with concrete services, messaging, data storage, and operational considerations, reflecting current use of Firebase (Auth, Firestore/Storage, FCM).

## Goals
- Modular agents for vision, nutrition, expiry, pantry, recipes, meal planning, health insights, chat, history, sync, notifications.
- Event-driven coordination with an orchestrator for long-running flows.
- Keep Firebase for auth and user-centric data; add Postgres for relational/analytics where needed.
- Support offline-first clients with background sync and conflict resolution.

## High-Level Architecture
- **API Gateway** (FastAPI or NestJS): Fronts mobile/web, validates Firebase JWTs, exposes REST/GraphQL, forwards intents to the orchestrator or directly to agents for simple reads.
- **Orchestrator** (Temporal/Prefect or custom): Manages workflows (scan-to-recipe, meal planning), retries, timeouts, and saga-style compensation.
- **Event Bus**: Kafka/Redpanda (preferred) or NATS JetStream for lightweight setups. DLQ per topic.
- **Agents/Services** (containerized; lightweight ones may run on Cloud Run/Functions):
  - FoodVision, Nutrition, Expiry, Recipe, Pantry, MealPlanner, Health, AIChat, UserProfile, Notification, History, Sync.
- **Storage**:
  - Firestore: users, profiles/preferences, pantry items, scans, meal plans, notifications state when joins are simple.
  - Postgres (or BigQuery): analytics, heavy joins, long-term history, embeddings index if needed.
  - Redis: caching, TTL for provisional expiry, rate limiting.
  - Object storage (Firebase Storage/S3-compatible): images from scans.
  - Client-side IndexedDB: offline cache for web; device storage for mobile.
- **LLM/ML**:
  - Food vision served via ONNX/TorchScript (Triton or FastAPI microservice).
  - Recipe generation via OpenAI/Anthropic; optional local fallback (Ollama).

## Service Responsibilities
- **FoodVision**: Detect ingredients, quantity, freshness; output ingredient list with confidence and freshness score.
- **Nutrition**: Enrich ingredients with nutrition facts, macros/micros, substitutes.
- **Expiry**: Predict expiry, spoilage risk, storage advice; set reminder times.
- **Pantry**: Source of truth for inventory, quantities, storage type, expiry links; low-stock detection.
- **Recipe**: Search/generate recipes; enforce dietary rules and allergies.
- **MealPlanner**: Builds daily/weekly plans, shopping lists, calorie/macro targets using pantry + user goals.
- **Health**: Aggregates trends, scores, and behavioral insights from history and meal plans.
- **AIChat**: Conversational interface; routes intents to orchestrator/agents; summarizes outputs.
- **UserProfile**: Preferences, dietary rules, allergies, notification settings, theme.
- **Notification**: Push via FCM; email via SES/SendGrid; deduplication and throttling.
- **History**: Logs scans, recipe usage, meal plans, notifications; enables re-analysis.
- **Sync**: Background replication across devices; conflict resolution policies.

## Messaging & Events
- **Topics (examples):** `scan.detected`, `nutrition.enriched`, `expiry.predicted`, `recipe.suggested`, `mealplan.updated`, `notification.requested`, `pantry.updated`, `sync.applied`.
- **Envelope:** correlation_id, user_id, agent, type, payload, created_at, trace_id.
- **Retries/DLQ:** per-topic DLQ with replay; idempotent handlers.
- **Contracts (compact examples):**
  - `scan.detected`: { ingredients: [{name, quantity, unit, confidence}], freshness_score, image_url, model_version }
  - `nutrition.enriched`: { items: [{name, calories, macros, micros, substitutes}], health_score }
  - `expiry.predicted`: { item_id, expiry_date, risk_level, storage_advice }
  - `mealplan.updated`: { plan_id, range, entries[{day, meal, recipe_id, servings}], nutrition_summary }

## Data Model (initial)
- **users** (Firestore): auth_provider_id, profile, preferences, dietary_rules.
- **user_preferences** (Firestore): dietary_preferences, allergies, health_goals, notification_prefs, theme.
- **pantry_items** (Firestore): name, quantity, unit, freshness_score, expiry_estimate, storage_type, last_seen_at, source(agent).
- **scans** (Firestore): image_url, detected_items, vision_meta(model_version, confidence), created_at.
- **recipes** (Postgres/Firestore hybrid): title, ingredients(list), instructions, nutrition_facts, source(model/api), embeddings(optional).
- **meal_plans** (Firestore): date_range, entries(recipe_id, servings), nutrition_summary.
- **notifications** (Firestore): type, payload, status, sent_at.
- **events** (Postgres/Kafka log sink): agent, type, payload, correlation_id, status, timestamps.

## Key Workflows
- **Scan-to-recipe**: UI → Gateway → Orchestrator → FoodVision → Nutrition → Expiry → Recipe → MealPlanner → Notification; History logs; Sync propagates.
- **Meal-plan generation**: UI → Gateway → Orchestrator → Pantry → Nutrition → MealPlanner → Notification; History + Sync persist.
- **Notification pipeline**: Agents emit `notification.requested`; Notification service formats and delivers via FCM/email; updates status in Firestore and History.

## Offline & Sync
- Local cache (IndexedDB/mobile storage) for pantry, preferences, recent plans.
- Optimistic updates; Sync agent reconciles with last-write-wins for quantities and vector-clock or per-field merge for preferences.
- Conflict strategy: pantry quantities use additive deltas; preferences use latest timestamp per field.

## Security
- Firebase Auth for user JWTs; gateway enforces validation.
- Service-to-service: Firebase custom tokens or service accounts; least-privilege Firestore rules.
- Encrypt images at rest; avoid storing raw PII in events; sign image URLs with short TTL.

## Observability & Resilience
- OpenTelemetry traces across gateway/orchestrator/agents; metrics via Prometheus/Grafana; logs via Loki/ELK.
- Circuit breakers and timeouts on external APIs (nutrition/LLM).
- Idempotent event handlers; DLQ with replay; rate limits on notification sends.

## Deployment
- Containerize agents; deploy to Kubernetes or Cloud Run for lighter services.
- Keep Firebase hosting/Firestore/Storage/FCM in place; Postgres managed (RDS/Cloud SQL) if/when added.
- CI/CD via GitHub Actions; IaC via Terraform/Helm where applicable.

