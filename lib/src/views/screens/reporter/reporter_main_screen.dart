import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/views/screens/reporter/alerts_screen.dart';
import 'package:pers/src/views/screens/reporter/home_screen.dart';
import 'package:pers/src/views/screens/reporter/locations_screen.dart';
import 'package:pers/src/views/screens/reporter/profile_screen.dart';
import 'package:pers/src/widgets/scroll_to_hide.dart';

class ReporterMainScreen extends StatefulWidget {
  ReporterMainScreen({Key? key}) : super(key: key);

  @override
  _ReporterMainScreenState createState() => _ReporterMainScreenState();
}

class _ReporterMainScreenState extends State<ReporterMainScreen> {
  PageController pageController = new PageController();
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> _barItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(CustomIcons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(CustomIcons.warning), label: 'Alerts'),
    BottomNavigationBarItem(
        icon: Icon(CustomIcons.location_pin), label: 'Locations'),
    BottomNavigationBarItem(icon: Icon(CustomIcons.user), label: 'Profile'),
  ];

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

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            HomeScreen(
              args: args,
              controller: controller,
            ),
            AlertsScreen(),
            LocationsScreen(),
            ProfileScreen(args: args),
          ],
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: ScrollToHideWidget(
        controller: controller,
        child: BottomNavigationBar(
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
