import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
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
  List<Widget>? pages;

  List<NavigationDestination> _navigationItems = [];

  initPages() {
    pages = [
      ResponderHomeScreen(),
      if (!isExternalAgency!) ResponderOperationsScreen(),
      ProfileScreen(isResponder: true),
    ];
  }

  initNavigationButtons() {
    _navigationItems = [
      NavigationDestination(
        icon: Icon(
          CustomIcons.home,
          color: contentColorLightTheme,
          size: 20,
        ),
        selectedIcon: Icon(
          CustomIcons.home,
          color: accentColor,
          size: 20,
        ),
        label: 'Home',
      ),
      if (!isExternalAgency!)
        NavigationDestination(
          icon: Icon(
            CustomIcons.siren_2,
            color: contentColorLightTheme,
          ),
          selectedIcon: Icon(
            CustomIcons.siren_2,
            color: accentColor,
            size: 20,
          ),
          label: 'Operations',
        ),
      NavigationDestination(
        icon: Icon(
          CustomIcons.user,
          color: contentColorLightTheme,
          size: 20,
        ),
        selectedIcon: Icon(
          CustomIcons.user,
          size: 20,
          color: accentColor,
        ),
        label: 'Profile',
      ),
    ];
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
      setState(() {
        user = User.fromJson(value);
        isLoading = false;
      });
      isExternalAgency = user!.account_type!.toUpperCase() == 'BFP' ||
          user!.account_type!.toUpperCase() == 'PNP';
      print(isExternalAgency);
      initPages();
      initNavigationButtons();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Logout'),
              content: Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () {
                    SharedPref().clear();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                  child: Text(
                    'YES',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'NO',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            );
          },
        );
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : pages![_selectedIndex],
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
                child: NavigationBar(
                  selectedIndex: _selectedIndex,
                  backgroundColor: Colors.white,
                  animationDuration: Duration(milliseconds: 500),
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  height: 70,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: _navigationItems,
                ),
              ),
      ),
    );
  }
}
