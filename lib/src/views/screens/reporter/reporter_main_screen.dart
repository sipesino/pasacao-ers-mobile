import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/views/screens/reporter/home_screen.dart';
import 'package:pers/src/views/screens/reporter/locations_screen.dart';
import 'package:pers/src/views/screens/reporter/profile_screen.dart';

class ReporterMainScreen extends StatefulWidget {
  ReporterMainScreen({Key? key}) : super(key: key);

  @override
  _ReporterMainScreenState createState() => _ReporterMainScreenState();
}

class _ReporterMainScreenState extends State<ReporterMainScreen> {
  PageController pageController = new PageController();
  int _selectedIndex = 0;

  List<NavigationDestination> _navigationItems = const [
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
    NavigationDestination(
      icon: Icon(
        FontAwesomeIcons.mapMarked,
        color: contentColorLightTheme,
        size: 20,
      ),
      selectedIcon: Icon(
        FontAwesomeIcons.mapMarked,
        color: accentColor,
        size: 20,
      ),
      label: 'Locations',
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

  List<Widget> pages = [
    HomeScreen(),
    // AlertsScreen(),
    LocationsScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        logout(context);
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: pages[_selectedIndex],
          ),
        ),
        bottomNavigationBar: myNavigationBar(),
      ),
    );
  }

  Widget myNavigationBar() {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: accentColor.withOpacity(0.2),
        backgroundColor: Color(0xFFF4F4FA),
      ),
      child: NavigationBar(
        selectedIndex: _selectedIndex,
        backgroundColor: Color(0xFFF4F4FA),
        animationDuration: Duration(milliseconds: 500),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        height: 70,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _navigationItems,
      ),
    );
  }

  Future<dynamic> logout(BuildContext context) {
    return showDialog(
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
  }
}
