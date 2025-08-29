import 'dart:ui';

import 'package:breaking_news/views/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController loginController = Get.put(LoginController());



  Future<void> _saveLoginData(String name, String email, String phone, String address) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),

        actions: [
          IconButton(
              onPressed: () {
                loginController.onrefresh();
              },
            icon: Icon(
              Icons.sync,
              color: Colors.white,  // Add your desired color here
            ),)
        ],
        title: const Text(
          "Breaking News",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Roboto',color: Colors.white,),
        ),
      ),
      body: Stack(
        children: [
          // Blurred background image
          SizedBox(
            height: size.height,
            width: size.width,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Image.asset(
                'assets/login_screen.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Dark overlay for contrast
          Container(
            height: size.height,
            width: size.width,
            color: Colors.black.withOpacity(0.3),
          ),

          // Centered login card with glassmorphism effect
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: size.width * 0.18,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/512px-Circle-icons-profile.svg.png',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Welcome!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black.withOpacity(0.9),
                            letterSpacing: 1.1,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black26,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Please login to continue",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                blurRadius: 3,
                                color: Colors.black26,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Obx(() => TextField(
                          controller: loginController.usernameController.value,
                          focusNode: loginController.usernameFocusNode,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                            ),
                          ),
                        )),
                        const SizedBox(height: 20),
                        Obx(() => TextField(
                          controller: loginController.passwordController.value,
                          focusNode: loginController.passwordFocusNode,
                          obscureText: true,
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.black),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.8), width: 2),
                            ),
                          ),
                        )),
                        const SizedBox(height: 30),
                        Obx(() => loginController.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        )
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loginController.login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(36, 54, 101, 1.0).withOpacity(0.85),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 10,
                              shadowColor: Colors.cyanAccent.withOpacity(0.6),
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        )),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(RegisterView());
                              },
                              child: const Text(
                                "Register Here",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                    color: Color.fromRGBO(36, 54, 101, 1.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
