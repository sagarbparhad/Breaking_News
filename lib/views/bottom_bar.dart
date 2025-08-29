import 'package:breaking_news/controllers/bottom_nav_bar.dart';
import 'package:breaking_news/views/profile_page.dart';
import 'package:breaking_news/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bottomnavigation/search_screen.dart';
import 'home_page.dart';

class BottomNavBar extends StatelessWidget {
  final TextStyle unselectedLabelStyle = TextStyle(
      color: Colors.grey.withOpacity(0.5),
      fontWeight: FontWeight.w500,
      fontSize: 12);

  final TextStyle selectedLabelStyle =
      TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12);

  BottomNavBar({super.key});


  @override
  Widget build(BuildContext context) {
    final BottomNavController landingPageController =
    Get.put(BottomNavController(), permanent: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar:
      buildBottomNavigationMenu(context, landingPageController),
      body: Obx(() => IndexedStack(
        index: landingPageController.tabIndex.value,
        children: [
          HomePage(),
          SearchScreen(),
          ProfilePage(
            address: '',
            phone: '',
            email: '',
            name: '',
          ),
          SettingsPage(),
        ],
      )),
    );
  }

  buildBottomNavigationMenu(context, landingPageController) {
    return Obx(() =>
        MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
            child: SizedBox(
              // height: 55,
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                showSelectedLabels: true,
                onTap: landingPageController.changeTabIndex,
                currentIndex: landingPageController.tabIndex.value,
                backgroundColor:Colors.cyan.shade100,
                unselectedItemColor: Colors.grey.withOpacity(0.5),
                selectedItemColor: Colors.white
                ,
                unselectedLabelStyle: unselectedLabelStyle,
                selectedLabelStyle: selectedLabelStyle,
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Icon(
                        Icons.home,
                        size: 20.0,
                      ),
                    ),
                    label: 'Home',
                    backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Icon(
                        Icons.search,
                        size: 20.0,
                      ),
                    ),
                    label: 'Search',
                    backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Icon(
                        Icons.person,
                        size: 20.0,
                      ),
                    ),
                    label: 'Profile',
                    backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
                  ),

                  BottomNavigationBarItem(
                    icon: Container(
                      margin: EdgeInsets.only(bottom: 7),
                      child: Icon(
                        Icons.settings,
                        size: 20.0,
                      ),
                    ),
                    label: 'Settings',
                    backgroundColor: Color.fromRGBO(36, 54, 101, 1.0),
                  ),
                ],
              ),
            )));
  }
}
