import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/views/screens/responder/responder_home_screen.dart';
import 'package:pers/src/views/screens/responder/responder_operations_screen.dart';
import 'package:pers/src/views/screens/responder/responder_profile_screen.dart';

class ResponderMainScreen extends StatefulWidget {
  ResponderMainScreen({Key? key}) : super(key: key);

  @override
  _ResponderMainScreenState createState() => _ResponderMainScreenState();
}

class _ResponderMainScreenState extends State<ResponderMainScreen> {
  PageController pageController = new PageController();
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> _barItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.siren_2),
      label: 'Operations',
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.user),
      label: 'Profile',
    ),
  ];

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ResponderHomeScreen(),
            ResponderOperationsScreen(),
            ResponderProfileScreen(),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          items: _barItems,
          currentIndex: _selectedIndex,
          unselectedItemColor: chromeColor,
          unselectedIconTheme: IconThemeData(color: chromeColor),
          selectedItemColor: accentColor,
          selectedIconTheme: IconThemeData(color: accentColor),
          onTap: onTap,
        ),
      ),
    );
  }
}
