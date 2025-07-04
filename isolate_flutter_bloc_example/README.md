# Flutter BLoC + Isolate Example

This Flutter application demonstrates how to use Flutter BLoC with Dart isolates to perform heavy computations in the background without blocking the UI thread.

## Key Features

- **BLoC Pattern**: Manages app state using the BLoC (Business Logic Component) pattern
- **Isolate Processing**: Heavy computations run in separate isolates to keep UI responsive
- **Background Processing**: Demonstrates how to perform CPU-intensive tasks without freezing the UI

## Implementation Details

### BLoC Architecture

The app uses three main components:

1. **NewsBloc** (`lib/bloc/news_bloc.dart`): Manages the state and handles events
2. **NewsEvent** (`lib/bloc/news_event.dart`): Defines events that trigger state changes
3. **NewsState** (`lib/bloc/news_state.dart`): Represents the current state of the app

### Isolate Usage

The heavy computation is performed in a separate isolate using:

- `Isolate.spawn()`: Creates a new isolate
- `ReceivePort` and `SendPort`: For communication between isolates
- `heavyComputation()`: The actual CPU-intensive function

### UI Components

- **HomePage** (`lib/pages/home_page.dart`): The main UI that displays results and triggers computations
- **BlocBuilder**: Rebuilds UI when state changes
- **LinearProgressIndicator**: Shows loading state during computation

## How It Works

1. User clicks "Start Heavy Computation" button
2. A `GetNews` event is dispatched to the BLoC
3. BLoC emits a loading state
4. Heavy computation runs in a separate isolate
5. Result is communicated back to the main isolate
6. BLoC emits the final result
7. UI updates to display the result

## Benefits

- **Responsive UI**: Main thread remains unblocked during heavy operations
- **Better User Experience**: Loading indicators and smooth interactions
- **Scalable**: Can handle multiple concurrent computations
- **Clean Architecture**: Separation of concerns using BLoC pattern

## Running the App

```bash
flutter pub get
flutter run
```

## Dependencies

- `flutter_bloc`: ^9.1.1 (for BLoC pattern implementation)
- `flutter`: SDK (for Flutter framework)

## Based on Medium Article

This implementation is based on the Medium article: 
"Flutter BLoC + Isolate: Enhancing Performance with Background Processing" 
by Mohammed Shamseer PV
