import 'package:breaking_news/controllers/language_controller.dart';
import 'package:breaking_news/controllers/theme_controller.dart';
import 'package:breaking_news/views/login_page.dart';
import 'package:breaking_news/views/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final LanguageController languageController = Get.put(LanguageController());

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode.value
          ? Colors.black
          : Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.0),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 10),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        // backgroundColor: const Color.fromRGBO(36, 54, 101, 1.0),
        backgroundColor:
        themeController.isDarkMode.value ? Colors.black : Color.fromRGBO(36, 54, 101, 1.0),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        children: [
          _buildSectionHeader("👤 Account"),
          _buildTile(
            context,
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Get.to(() => ProfilePage(
                address: 'Pune, India',
                phone: '9876543210',
                email: 'sagar@example.com',
                name: 'Sagar Parhad',
              ));
            },
          ),
          _buildTile(
            context,
            icon: Icons.lock,
            title: "Change Password",
            onTap: () {
              Get.snackbar("Change Password", "Feature under development",
                  snackPosition: SnackPosition.BOTTOM);
            },
          ),
          _buildTile(
            context,
            icon: Icons.logout,
            title: "Logout",
            onTap: _logOut,
          ),

          _buildSectionHeader("🔔 Notifications"),
          Obx(() => SwitchListTile(
            title: const Text("Breaking News Alerts"),
            secondary: const Icon(Icons.notifications_active),
            value: themeController.breakingNewsAlerts.value,
            onChanged: (val) =>
            themeController.breakingNewsAlerts.value = val,
          )),

          _buildSectionHeader("🎨 Appearance"),
          Obx(() => SwitchListTile(
            title: const Text("Dark Mode"),
            secondary: const Icon(Icons.dark_mode),
            value: themeController.isDarkMode.value,
            onChanged: (val) => themeController.toggleTheme(),
          )),
          _buildTile(context,
              icon: Icons.text_fields,
              title: "Font Size",
              onTap: () {
                Get.defaultDialog(
                  title: "Font Size",
                  content: Column(
                    children: [
                      ListTile(
                        title: const Text("Small"),
                        onTap: () => Get.snackbar(
                            "Font Size", "Changed to Small",
                            snackPosition: SnackPosition.BOTTOM),
                      ),
                      ListTile(
                        title: const Text("Medium"),
                        onTap: () => Get.snackbar(
                            "Font Size", "Changed to Medium",
                            snackPosition: SnackPosition.BOTTOM),
                      ),
                      ListTile(
                        title: const Text("Large"),
                        onTap: () => Get.snackbar(
                            "Font Size", "Changed to Large",
                            snackPosition: SnackPosition.BOTTOM),
                      ),
                    ],
                  ),
                );
              }),

          _buildSectionHeader("🌐 Content Preferences"),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            trailing: Obx(() => DropdownButton<String>(
              value: languageController.selectedLanguage.value,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
                DropdownMenuItem(value: 'mr', child: Text('Marathi')),
              ],
              onChanged: (String? newLang) {
                if (newLang != null) {
                  languageController.changeLanguage(newLang);
                  Get.snackbar("Language Changed",
                      "App language set to ${newLang.toUpperCase()}",
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            )),
          ),

          _buildSectionHeader("🔒 Privacy & Security"),
          _buildTile(context,
              icon: Icons.security,
              title: "Manage Permissions",
              onTap: () {
                Get.snackbar("Permissions", "Redirecting to Settings...",
                    snackPosition: SnackPosition.BOTTOM);
              }),
          _buildTile(context,
              icon: Icons.storage,
              title: "Data & Cache",
              onTap: () {
                Get.snackbar("Data Cleared", "Cache successfully cleared!",
                    snackPosition: SnackPosition.BOTTOM);
              }),

          _buildSectionHeader("📞 Support"),
          _buildTile(context,
              icon: Icons.info,
              title: "About",
              onTap: () {
                Get.defaultDialog(
                  title: "About App",
                  content: const Text(
                      "Breaking News App\nVersion 1.0.0\nDeveloped by Sagar"),
                );
              }),
          _buildTile(context,
              icon: Icons.support,
              title: "Contact Support",
              onTap: () {
                Get.defaultDialog(
                  title: "Contact Support",
                  content: const Text(
                      "Breaking News App\nEmail Id : sagarparhad@123gmail.com\nContact No. : 8767225263"),
                );
              }),
          ListTile(
            leading: const Icon(Icons.verified),
            title: const Text("App Version"),
            subtitle: const Text("1.0.0"),
          ),

          _buildSectionHeader("⚙️ Advanced"),
          _buildTile(context,
              icon: Icons.settings_backup_restore,
              title: "Reset App Settings",
              onTap: () {
                Get.defaultDialog(
                  title: "Reset Settings",
                  middleText: "Are you sure you want to reset all settings?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    themeController.isDarkMode.value = false;
                    themeController.breakingNewsAlerts.value = true;
                    languageController.changeLanguage("en");
                    Get.back();
                    Get.snackbar("Reset", "Settings have been reset!",
                        snackPosition: SnackPosition.BOTTOM);
                  },
                );
              }),
        ],
      ),
    );
  }

  /// Styled section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  /// Reusable Tile UI
  Widget _buildTile(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _logOut() {
    Get.offAll(() => LoginView()); // Clear stack and go to Login
  }
}
