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
