import 'package:breaking_news/views/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/login_model.dart';

class LoginController extends GetxController {
  Rx<User> user = User(username: "", password: "").obs;
  var isLoading = false.obs;
  Rx<TextEditingController> usernameController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  late FocusNode usernameFocusNode;
  late FocusNode passwordFocusNode;

  // User data storage
  List<User> loginData = [
    User(username: "sagar", password: "sagar1"),
    User(username: "sikandar", password: "sikandar"),
  ];

  void registerUser() {
    String username = usernameController.value.text.trim();
    String password = passwordController.value.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username and password cannot be empty",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Check if username already exists
    bool userExists = loginData.any((user) => user.username == username);
    if (userExists) {
      Get.snackbar("Error", "Username already exists",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Add new user
    loginData.add(User(username: username, password: password));
    Get.snackbar("Success", "Registration successful! Please login.",
        backgroundColor: Colors.green, colorText: Colors.white);

    // Clear input fields
    usernameController.value.clear();
    passwordController.value.clear();
  }

  void login() async {
    String username = usernameController.value.text.trim();
    String password = passwordController.value.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter your username and password",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading(true);
    await Future.delayed(Duration(seconds: 2));

    bool isValid = loginData.any((user) => user.username == username && user.password == password);

    isLoading(false);
    if (isValid) {
      Get.snackbar("Login Success", "Welcome, $username!",
          backgroundColor: Color.fromRGBO(36, 54, 101, 1.0), colorText: Colors.white);
      Get.to(BottomNavBar());
    } else {
      Get.snackbar("Login Failed", "Invalid username or password",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  onrefresh() {
    usernameController.value.clear();
    passwordController.value.clear();
    FocusScope.of(Get.context!).requestFocus(FocusNode());
  }

  @override
  void onInit() {
    super.onInit();
    passwordFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    usernameController.close();
    passwordController.close();
    super.dispose();
  }
}
