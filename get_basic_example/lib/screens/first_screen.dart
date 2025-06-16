import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/simple_controller.dart';
import '../routes/app_routes.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Get.snackbar("Hi", "I'm modern snackbar");
          },
        ),
        title: Text("title".trArgs(['John'])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<SimpleController>(
              init: SimpleController(),
              builder: (controller) => Text('clicks: ${controller.count}'),
            ),
            ElevatedButton(
              child: Text('Next Route'),
              onPressed: () {
                Get.toNamed(Routes.SECOND);
              },
            ),
            ElevatedButton(
              child: Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.find<SimpleController>().increment();
        },
      ),
    );
  }
}
