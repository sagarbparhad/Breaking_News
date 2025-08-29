import 'package:breaking_news/models/localization.dart';
import 'package:breaking_news/views/login_page.dart';
import 'package:breaking_news/views/profile_page.dart';
import 'package:breaking_news/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Load profile data if available
  String name = prefs.getString('name') ?? "";
  String email = prefs.getString('email') ?? "";
  String phone = prefs.getString('phone') ?? "";
  String address = prefs.getString('address') ?? "";

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    name: name,
    email: email,
    phone: phone,
    address: address,
  ));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final String name;
  final String email;
  final String phone;
  final String address;

  const MyApp({
    super.key,
    required this.isLoggedIn,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breaking News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      translations: AppTranslations(),
      locale: const Locale('en'), // Default Language
      fallbackLocale: const Locale('en'),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      // 👇 Decide which screen to open first
      home: widget.isLoggedIn
          ? ProfilePage(
        name: widget.name,
        email: widget.email,
        phone: widget.phone,
        address: widget.address,
      )
          : const LoginView(),
      getPages: [
        GetPage(
          name: '/newsWebView',
          page: () => const FullArticleScreen(url: '', imageUrl: ''), // default
        ),
      ],
    );
  }
}