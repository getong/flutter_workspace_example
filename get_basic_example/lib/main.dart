import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_pages.dart';
import 'translations/app_translations.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: AppPages.INITIAL,
      defaultTransition: Transition.native,
      translations: AppTranslations(),
      locale: Locale('pt', 'BR'),
      getPages: AppPages.routes,
    ),
  );
}
