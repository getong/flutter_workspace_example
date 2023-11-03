import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // You define here the design's size (design draft dimensions)
      designSize: Size(360, 690),
      builder: (context, child) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initializing ScreenUtil for setting up width, height, and font size
    ScreenUtil.init(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ScreenUtil Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'This is 18sp text',
              style: TextStyle(
                // Setting text size using ScreenUtil
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 20.h), // Use '.h' for height sizing
            Container(
              width: 0.5.sw, // Use '.sw' for screen width sizing
              height: 100.h, // Use '.h' for height sizing
              color: Colors.blue,
              child: Center(
                child: Text(
                  'This is a container with 50% of screen width',
                  style: TextStyle(
                    fontSize:
                        14.sp, // '.sp' will also respect the text scale factor
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
