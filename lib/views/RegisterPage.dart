import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
        title: const Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Welcome to the News App!",
                  style: TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: MediaQuery.of(context).size.width / 5,
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/512px-Circle-icons-profile.svg.png'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: loginController.usernameController.value,
                  // focusNode: loginController.usernameFocusNode,
                  decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: loginController.passwordController.value,
                  // focusNode: loginController.passwordFocusNode,
                  decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.all(
                              Radius.circular(20))),
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.black)),
                  cursorColor: Colors.black,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(36, 54, 101, 1.0).withOpacity(0.85),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 10,
                      shadowColor: Colors.cyanAccent.withOpacity(0.6),
                    ),
                    onPressed: () {
                      loginController.registerUser();
                    },
                    child: const Text("Register", style: TextStyle(
                        fontSize: 18, color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
