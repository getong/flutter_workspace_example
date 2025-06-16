import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/advanced_controller.dart';
import '../routes/app_routes.dart';

class SecondScreen extends GetView<AdvancedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('second Route')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              print("count1 rebuild");
              return Text('${controller.count1}');
            }),
            Obx(() {
              print("count2 rebuild");
              return Text('${controller.count2}');
            }),
            Obx(() {
              print("sum rebuild");
              return Text('${controller.sum}');
            }),
            Obx(() => Text('Name: ${controller.user.value.name}')),
            Obx(() => Text('Age: ${controller.user.value.age}')),
            ElevatedButton(
              child: Text("Go to last page"),
              onPressed: () {
                Get.toNamed(Routes.THIRD, arguments: 'arguments of second');
              },
            ),
            ElevatedButton(
              child: Text("Back page and open snackbar"),
              onPressed: () {
                Get.back();
                Get.snackbar('User 123', 'Successfully created');
              },
            ),
            ElevatedButton(
              child: Text("Increment"),
              onPressed: () {
                controller.increment();
              },
            ),
            ElevatedButton(
              child: Text("Increment 2"),
              onPressed: () {
                controller.increment2();
              },
            ),
            ElevatedButton(
              child: Text("Update name"),
              onPressed: () {
                controller.updateUser();
              },
            ),
            ElevatedButton(
              child: Text("Dispose worker"),
              onPressed: () {
                controller.disposeWorker();
              },
            ),
          ],
        ),
      ),
    );
  }
}
