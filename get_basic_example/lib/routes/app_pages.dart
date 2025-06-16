import 'package:get/get.dart';
import '../screens/first_screen.dart';
import '../screens/second_screen.dart';
import '../screens/third_screen.dart';
import '../bindings/sample_binding.dart';
import '../transitions/size_transitions.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(name: Routes.HOME, page: () => FirstScreen()),
    GetPage(
      name: Routes.SECOND,
      page: () => SecondScreen(),
      customTransition: SizeTransitions(),
      binding: SampleBinding(),
    ),
    GetPage(
      name: Routes.THIRD,
      transition: Transition.cupertino,
      page: () => ThirdScreen(),
    ),
  ];
}
