import 'package:get/get.dart';
import '../controllers/advanced_controller.dart';

class SampleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdvancedController>(() => AdvancedController());
  }
}
