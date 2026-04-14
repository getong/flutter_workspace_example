# Running the Backend Server

## Option 1: Node.js Server (Recommended)

1. **Install Node.js** (if not already installed)
   - Visit https://nodejs.org/ and install LTS version

2. **Run the server:**
   ```bash
   cd /Users/gerald/personal_infos/flutter_workspace_example/bloc_workspace_example/flutter_bloc_dio_protobuf_example
   node server.js
   ```

   You should see:
   ```
   Server running at http://127.0.0.1:8080/
   Press Ctrl+C to stop the server
   ```

3. **Keep the server running** in a separate terminal while testing your Flutter app

## Option 2: Alternative - Mock Mode in Flutter

If you don't want to run a server, you can modify `main.dart` to use a mock mode:
- Uncomment the mock code in the Flutter app
- The app will simulate responses without needing a real server

## Testing

1. Start the server (Option 1 above)
2. Run your Flutter app:
   ```bash
   flutter run
   ```
3. Tap "Send Message" button in the app
4. Check the server logs to see the received message

## Troubleshooting

If you still get "Connection refused":
- Make sure the server is running on the correct port (8080)
- Check that localhost:8080 is accessible
- On iOS/Android emulator, you may need to use `10.0.2.2` instead of `localhost`
