import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set system overlays and status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, // Set status bar color to blue
      systemNavigationBarColor: Colors.blue, // Set navigation bar color to blue
      statusBarIconBrightness:
          Brightness.light, // Set status bar icons to light (dark background)
      systemNavigationBarIconBrightness: Brightness
          .light, // Set navigation bar icons to light (dark background)
    ));
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      title: 'SystemChrome Example',
      home: Scaffold(
        appBar: AppBar(
          title: Text('SystemChrome Example'),
        ),
        body: Center(
          child: Text(
            'Customizing SystemChrome',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
