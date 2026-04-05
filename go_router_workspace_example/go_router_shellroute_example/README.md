# GoRouter ShellRoute Example

A Flutter project demonstrating the use of GoRouter's ShellRoute for creating persistent navigation structures.

## Overview

This example showcases how to implement a bottom navigation bar that persists across different pages using GoRouter's `ShellRoute` feature. The app includes multiple tabs with nested routing capabilities.

## Features Demonstrated

### 🎯 Core Features
- **Persistent Navigation**: Bottom navigation bar that remains visible across all pages
- **Nested Routing**: Routes within the shell structure
- **Parameter Passing**: Passing data between routes
- **Multiple Navigation Methods**: Using `go()`, `push()`, and named routes

### 📱 App Structure
```
Shell (Persistent Bottom Navigation)
├── Home Tab (/home)
│   └── Details Page (/home/details/:id)
├── Profile Tab (/profile)
└── Settings Tab (/settings)
```

## Key Concepts

### ShellRoute
`ShellRoute` is a special type of route in GoRouter that allows you to define a persistent widget (like a bottom navigation bar) that remains visible while the content area changes based on the current route.

### Route Configuration
```dart
ShellRoute(
  builder: (context, state, child) {
    return ShellWidget(child: child);
  },
  routes: [
    // Child routes here will be displayed within the shell
  ],
)
```

### Navigation Methods

1. **Go Navigation**: Replaces the current route
   ```dart
   context.go('/home/details/123');
   ```

2. **Push Navigation**: Adds to the navigation stack
   ```dart
   context.push('/home/details/456');
   ```

3. **Named Routes**: Using route names instead of paths
   ```dart
   context.goNamed('details', pathParameters: {'id': '789'});
   ```

## File Structure

```
lib/
├── main.dart              # App entry point with GoRouter setup
├── router.dart            # Router configuration with ShellRoute
├── shell_widget.dart      # Persistent shell with bottom navigation
└── pages/
    ├── home_page.dart     # Home page with navigation examples
    ├── profile_page.dart  # Profile page
    ├── settings_page.dart # Settings page
    └── details_page.dart  # Details page with parameter handling
```

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK

### Dependencies
Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^13.0.0  # Check for latest version
```

### Installation
1. Clone this repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Usage Examples

### Basic Navigation
Navigate between tabs using the bottom navigation bar. The navigation state persists across all pages.

### Nested Navigation
From the Home tab, you can navigate to detail pages while maintaining the bottom navigation structure.

### Parameter Passing
The details page demonstrates how to pass and retrieve parameters from routes:
```dart
// In route definition
GoRoute(
  path: '/details/:id',
  pageBuilder: (context, state) {
    final id = state.pathParameters['id'] ?? '0';
    return MaterialPage(child: DetailsPage(id: id));
  },
)

// In widget
class DetailsPage extends StatelessWidget {
  final String id;
  const DetailsPage({required this.id});
  // ...
}
```

## Benefits of ShellRoute

1. **Consistent UI**: Bottom navigation remains visible and functional across all pages
2. **Better UX**: Users can quickly switch between main sections without losing context
3. **State Preservation**: Navigation state is maintained across route changes
4. **Performance**: Efficient rendering with minimal widget rebuilding

## Common Use Cases

- **Bottom Navigation Apps**: Perfect for apps with 3-5 main sections
- **Tab-based Interfaces**: When you need persistent tabs across pages
- **Dashboard Applications**: Apps with sidebar navigation that should persist
- **E-commerce Apps**: Product browsing with persistent cart/profile access

## Learning Resources

- [GoRouter Documentation](https://docs.flutter.dev/development/ui/navigation/url-strategies)
- [Flutter Navigation Guide](https://docs.flutter.dev/development/ui/navigation)
- [GoRouter Package](https://pub.dev/packages/go_router)

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is for educational purposes and follows Flutter's sample project guidelines.
