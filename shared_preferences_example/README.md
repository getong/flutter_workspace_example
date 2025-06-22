# shared_preferences_example

A Flutter project demonstrating the usage of SharedPreferences for persistent data storage with GoRouter navigation, organized in a clean, modular structure.

## Project Structure

```
lib/
├── main.dart                    # App entry point and configuration
├── router/
│   └── app_router.dart         # GoRouter configuration
├── pages/
│   ├── counter_page.dart       # Counter demonstration page
│   ├── settings_page.dart      # Settings page with theme toggle
│   └── profile_page.dart       # Profile page with user data
└── services/
    └── preferences_service.dart # Centralized SharedPreferences operations
```

## Features

This app demonstrates how to use SharedPreferences with GoRouter to:
- Save data that persists across app sessions
- Load previously saved data when the app starts
- Navigate between different screens while maintaining state
- Store different types of data (int, bool, string)

### Pages Included

1. **Counter Page** (`/`): 
   - Increments when you tap the floating action button
   - Automatically saves the current value to SharedPreferences
   - Loads the saved value when the app starts
   - Can be reset to zero using the reset button

2. **Settings Page** (`/settings`):
   - Theme preference toggle (Dark Mode)
   - Demonstrates boolean storage with SharedPreferences
   - Settings persist across app sessions

3. **Profile Page** (`/profile`):
   - User profile form with username and email fields
   - Demonstrates string storage with SharedPreferences
   - Save and clear profile functionality

## SharedPreferences Usage

### Key Methods Demonstrated

1. **Loading data**: Using PreferencesService methods
   - `PreferencesService.getCounter()` for integers
   - `PreferencesService.getDarkMode()` for booleans  
   - `PreferencesService.getUsername()` and `PreferencesService.getEmail()` for strings

2. **Saving data**: Using PreferencesService methods
   - `PreferencesService.setCounter(value)` for integers
   - `PreferencesService.setDarkMode(value)` for booleans
   - `PreferencesService.setUsername(value)` and `PreferencesService.setEmail(value)` for strings

3. **Removing data**: Using PreferencesService methods
   - `PreferencesService.removeCounter()`
   - `PreferencesService.removeUsername()` and `PreferencesService.removeEmail()`

## Architecture Benefits

- **Separation of Concerns**: Pages, routing, and data persistence are separated into different directories
- **Centralized Data Management**: All SharedPreferences operations are handled in a single service class
- **Reusability**: The PreferencesService can be easily used across different pages
- **Maintainability**: Clear file organization makes the code easier to understand and modify
- **Type Safety**: Specific methods for different data types reduce errors

## GoRouter Integration

The app uses GoRouter for navigation between screens:

```dart
final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CounterPage(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfilePage(),
    ),
  ],
);
```

### Navigation Examples

```dart
// Navigate to settings page
context.go('/settings');

// Navigate back to home
context.go('/');
```

### Code Example

```dart
// Load saved counter value
_loadCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _counter = (prefs.getInt('counter') ?? 0);
  });
}

// Save counter value
void _incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _counter++;
  });
  await prefs.setInt('counter', _counter);
}

// Load theme preference
_loadThemePreference() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
  });
}

// Save user profile data
_saveUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', _username);
  await prefs.setString('email', _email);
}
```

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2
  go_router: ^12.1.3
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
