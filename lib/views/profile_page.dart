import 'package:breaking_news/views/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));
    }
  }

  Future<void> _logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clears all login + profile info

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }


  /*void _logOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginView()),
    );
  }*/

  // Local variables (so they can change when edited)
  late String _updatedName;
  late String _updatedEmail;
  late String _updatedPhone;
  late String _updatedAddress;

  @override
  void initState() {
    super.initState();
    _updatedName = widget.name;
    _updatedEmail = widget.email;
    _updatedPhone = widget.phone;
    _updatedAddress = widget.address;
  }
  Widget buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.shade100,
          child: Icon(icon, color: Colors.indigo),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER WITH GRADIENT
          Container(
            width: double.infinity,
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF243665), Color(0xFF4E67C8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      backgroundColor: Colors.white,
                      child: _profileImage == null
                          ? const Icon(Icons.person, size: 60, color: Colors.grey)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.indigo),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(widget.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),

          // BODY INFO
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildInfoCard("Name", _updatedName, Icons.person),
                  buildInfoCard("Email", _updatedEmail, Icons.email),
                  buildInfoCard("Phone", _updatedPhone, Icons.phone),
                  buildInfoCard("Address", _updatedAddress, Icons.home),
                  buildInfoCard("Age", "23 years", Icons.cake),
                  buildInfoCard("Gender", "Male", Icons.male),
                  buildInfoCard("Country", "India", Icons.flag),
                  buildInfoCard("Bio",
                      "Passionate Flutter & Web Developer who loves building apps.",
                      Icons.info),
                  buildInfoCard("Joined", "Aug 2025", Icons.calendar_today),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            name: widget.name,
                            email: widget.email,
                            phone: widget.phone,
                            address: widget.address,
                          ),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          // Update state with new values
                          // result is a Map from EditProfilePage
                          _updatedName = result['name'];
                          _updatedEmail = result['email'];
                          _updatedPhone = result['phone'];
                          _updatedAddress = result['address'];
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _logOut,
                    icon: const Icon(Icons.logout),
                    label: const Text("Log Out"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
