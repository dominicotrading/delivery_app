import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class LanguageController extends GetxController {
  final _box = GetStorage();
  final _key = 'language';

  String get language => _loadLanguageFromBox();

  String _loadLanguageFromBox() => _box.read(_key) ?? 'en_US';

  void saveLanguage(String language) {
    _box.write(_key, language);
  }

  void changeLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
    saveLanguage(languageCode);
  }

  @override
  void onInit() {
    super.onInit();
    Get.updateLocale(Locale(language));
  }
} 