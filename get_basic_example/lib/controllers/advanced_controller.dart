import 'package:get/get.dart';
import '../models/user.dart';

class AdvancedController extends GetxController {
  final count1 = 0.obs;
  final count2 = 0.obs;
  final list = [56].obs;
  final user = User().obs;
  late Worker _ever;

  int get sum => count1.value + count2.value;

  void updateUser() {
    user.update((value) {
      value!.name = 'Jose';
      value.age = 30;
    });
  }

  @override
  void onInit() {
    super.onInit();
    _setupWorkers();
  }

  void _setupWorkers() {
    _ever = ever(count1, (value) => print("$value has been changed (ever)"));

    everAll([
      count1,
      count2,
    ], (values) => print("$values has been changed (everAll)"));

    once(count1, (value) => print("$value was changed once (once)"));

    debounce(
      count1,
      (value) => print("debouce$value (debounce)"),
      time: Duration(seconds: 1),
    );

    interval(
      count1,
      (value) => print("interval $value (interval)"),
      time: Duration(seconds: 1),
    );
  }

  void increment() => count1.value++;
  void increment2() => count2.value++;
  void incrementList() => list.add(75);

  void disposeWorker() {
    _ever.dispose();
  }
}
