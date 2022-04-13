import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/views/screens/reporter/profile_screen.dart';
import 'package:pers/src/views/screens/responder/responder_home_screen.dart';
import 'package:pers/src/views/screens/responder/responder_operations_screen.dart';

class ResponderMainScreen extends StatefulWidget {
  ResponderMainScreen({Key? key}) : super(key: key);

  @override
  _ResponderMainScreenState createState() => _ResponderMainScreenState();
}

class _ResponderMainScreenState extends State<ResponderMainScreen> {
  PageController pageController = new PageController();
  bool? isExternalAgency;
  int _selectedIndex = 0;
  bool isLoading = true;

  List<BottomNavigationBarItem> _barItems = [];

  initBottomBarItems() {
    _barItems.add(
      BottomNavigationBarItem(
        icon: Icon(CustomIcons.home),
        label: 'Home',
      ),
    );
    if (!isExternalAgency!) {
      _barItems.add(
        BottomNavigationBarItem(
          icon: Icon(CustomIcons.siren_2),
          label: 'Operations',
        ),
      );
    }
    _barItems.add(
      BottomNavigationBarItem(
        icon: Icon(CustomIcons.user),
        label: 'Profile',
      ),
    );
  }

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
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPref().read('user').then((value) {
      User user = User.fromJson(value);
      isExternalAgency = user.account_type!.toUpperCase() == 'EXTERNAL AGENCY';
      initBottomBarItems();
      print(_barItems.length);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ResponderHomeScreen(),
                  if (!isExternalAgency!) ResponderOperationsScreen(),
                  ProfileScreen(isResponder: true),
                ],
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
      ),
      bottomNavigationBar: isLoading
          ? SizedBox.shrink()
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 0.4,
                  ),
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
