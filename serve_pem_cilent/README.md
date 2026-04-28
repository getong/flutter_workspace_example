# serve_pem_cilent

Flutter client for two feature areas:

- `advice`
- `serve_pem`

The app uses `auto_route` with `auto_route_generator`. Each routable page is
annotated directly above the widget class with `@RoutePage()`, and the router
definition lives in [lib/core/routing/app_router.dart](lib/core/routing/app_router.dart).

## Route Generation

Generate routing, JSON, and DI code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Keep generators running while editing routes:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

The `auto_route` builder is enabled in `build.yaml`, and `@AutoRouterConfig`
scopes generation to `lib/`.

## client of rust_example

aws_lc_rs_workspace_example/serve_pem

## Serve PEM Flow

The Rust service now exposes three client-relevant endpoints:

- `GET /public-key`
- `POST /register`
- `POST /login`

The client fetches the server RSA public key from `/public-key`, generates a
random 32-byte AES key plus a random 12-byte nonce, encrypts the JSON payload
with `AES-256-GCM`, wraps the AES key with `RSA-OAEP-SHA256`, and posts:

```json
{
  "wrapped_key_base64": "...",
  "nonce_base64": "...",
  "ciphertext_base64": "..."
}
```

The `/register` and `/login` responses both include:

```json
{
  "status": "registered or authenticated",
  "user_id": 1,
  "client_public_key_sha256": "..."
}
```
