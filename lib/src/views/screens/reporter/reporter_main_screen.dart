import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  late ScreenArguments args;
  int _selectedIndex = 0;

  List<BottomNavigationBarItem> _barItems = [
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.warning),
      label: 'Alerts',
    ),
    BottomNavigationBarItem(
      icon: Icon(FontAwesomeIcons.mapMarked),
      label: 'Locations',
    ),
    BottomNavigationBarItem(
      icon: Icon(CustomIcons.user),
      label: 'Profile',
    ),
  ];

  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
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
            LocationsScreen(
              controller: controller,
            ),
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
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: new Offset(0, -5),
                blurRadius: 20.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: _barItems,
            currentIndex: _selectedIndex,
            unselectedItemColor: chromeColor,
            unselectedIconTheme: IconThemeData(color: chromeColor),
            selectedItemColor: accentColor,
            selectedIconTheme: IconThemeData(color: accentColor),
            onTap: (index) {
              pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              setState(() {
                _selectedIndex = index;
              });
            },
            showUnselectedLabels: true,
          ),
        ),
      ),
    );
  }
}
