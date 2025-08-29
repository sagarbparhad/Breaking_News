import 'package:breaking_news/controllers/language_controller.dart';
import 'package:breaking_news/controllers/theme_controller.dart';
import 'package:breaking_news/views/login_page.dart';
import 'package:breaking_news/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.find<LanguageController>();

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        children: [
          _section('account'.tr),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text('profile'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => ProfilePage(
                address: '',
                phone: '',
                email: '',
                name: '',
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('change_password'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _logOut,
          ),

          _section('notifications'.tr),
          Obx(() => SwitchListTile(
            title: Text('breaking_news_alerts'.tr),
            value: themeController.breakingNewsAlerts.value,
            onChanged: (val) =>
            themeController.breakingNewsAlerts.value = val,
          )),

          _section('appearance'.tr),
          Obx(() => SwitchListTile(
            title: Text('dark_mode'.tr),
            value: themeController.isDarkMode.value,
            onChanged: (_) => themeController.toggleTheme(),
          )),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: Text('font_size'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          _section('content_prefs'.tr),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language'.tr),
            trailing: Obx(() => DropdownButton<String>(
              value: languageController.selectedLanguage.value,
              underline: const SizedBox(),
              items: [
                DropdownMenuItem(
                    value: 'en', child: Text('english'.tr)),
                DropdownMenuItem(value: 'hi', child: Text('hindi'.tr)),
                DropdownMenuItem(value: 'mr', child: Text('marathi'.tr)),
              ],
              onChanged: (code) {
                if (code == null) return;
                languageController.changeLanguage(code);
                final shown = switch (code) {
                  'hi' => 'hindi'.tr,
                  'mr' => 'marathi'.tr,
                  _ => 'english'.tr,
                };
                Get.snackbar('language'.tr, '${'lang_changed_to'.tr} $shown',
                    snackPosition: SnackPosition.BOTTOM);
              },
            )),
          ),

          _section('privacy_security'.tr),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('manage_permissions'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.storage),
            title: Text('data_cache'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          _section('support'.tr),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('about'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: Text('contact_support'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.verified),
            title: Text('${'app_version'.tr} 1.0.0'),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  );

  void _logOut() => Get.offAll(() => LoginView());
}
