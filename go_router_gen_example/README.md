# Go Router Gen Example

This Flutter project demonstrates how to use `go_router` with code generation using `go_router_builder`.

## Features

- Type-safe routing with code generation
- Parameterized routes
- Navigation between multiple screens
- Clean route organization

## Project Structure

```
lib/
├── main.dart           # App entry point
├── router.dart         # Route definitions (generates router.g.dart)
└── screens/
    ├── home_screen.dart    # Home screen
    ├── profile_screen.dart # Profile screen
    └── details_screen.dart # Details screen with ID parameter
```

## Routes

- `/` - Home screen
- `/profile` - Profile screen  
- `/details/:id` - Details screen with dynamic ID parameter

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate the router code:
   ```bash
   dart run build_runner build
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## How it Works

### 1. Route Definitions

Routes are defined using `@TypedGoRoute` annotations in `router.dart`:

```dart
@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProfileRoute>(path: '/profile'),
    TypedGoRoute<DetailsRoute>(path: '/details/:id'),
  ],
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}
```

### 2. Code Generation

The `go_router_builder` package generates:
- Type-safe route classes
- Navigation extensions
- Parameter validation

### 3. Navigation

Use the generated route classes for type-safe navigation:

```dart
// Navigate to profile
const ProfileRoute().go(context);

// Navigate to details with parameter
const DetailsRoute(id: '123').go(context);
```

## Benefits

- **Type Safety**: Compile-time route validation
- **Parameter Safety**: Required parameters are enforced
- **Auto-completion**: IDE support for routes and parameters
- **Refactoring Safe**: Route changes are caught at compile time

## Development

To regenerate routes after making changes:

```bash
# One-time generation
dart run build_runner build

# Watch for changes and regenerate automatically
dart run build_runner watch
```
