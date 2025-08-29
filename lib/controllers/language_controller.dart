import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  // 'en', 'hi', 'mr'
  final RxString selectedLanguage = 'en'.obs;
  final Rx<Locale> locale = const Locale('en', 'US').obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _storage.read<String>('lang') ?? 'en';
    changeLanguage(saved, save: false);
  }

  void changeLanguage(String code, {bool save = true}) {
    final Locale newLocale = switch (code) {
      'hi' => const Locale('hi', 'IN'),
      'mr' => const Locale('mr', 'IN'),
      _ => const Locale('en', 'US'),
    };

    selectedLanguage.value = code;
    locale.value = newLocale;

    // Make GetMaterialApp rebuild with the new locale
    Get.updateLocale(newLocale);

    if (save) _storage.write('lang', code);
  }
}
