import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/advanced_controller.dart';

class ThirdScreen extends GetView<AdvancedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.incrementList();
        },
      ),
      appBar: AppBar(title: Text("Third ${Get.arguments}")),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.list.length,
            itemBuilder: (context, index) {
              return Text("${controller.list[index]}");
            },
          ),
        ),
      ),
    );
  }
}
