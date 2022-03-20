import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/notification_api.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/views/screens/responder/responder_home_screen.dart';
import 'package:pers/src/views/screens/responder/responder_operations_screen.dart';
import 'package:pers/src/views/screens/responder/responder_profile_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

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

  final String taskName = 'awaitOperationTask';

  @override
  void initState() {
    // setupBackgroundTask();

    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    if (mounted) super.setState(fn);
  }

  void listenToNotifications() =>
      NotificationAPI.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) {
    Navigator.pushNamed(
      context,
      '/responder/home/new_operation',
      arguments: ScreenArguments(
        payload: payload,
      ),
    );
  }

  setupBackgroundTask() async {
    NotificationAPI.init();
    listenToNotifications();
    await Workmanager().initialize(callbackDispatcher);
    await Workmanager().registerPeriodicTask(
      "1",
      taskName,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
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
      bottomNavigationBar: BottomNavigationBar(
        items: _barItems,
        currentIndex: _selectedIndex,
        unselectedItemColor: chromeColor,
        unselectedIconTheme: IconThemeData(color: chromeColor),
        selectedItemColor: accentColor,
        selectedIconTheme: IconThemeData(color: accentColor),
        onTap: onTap,
      ),
    );
  }
}

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    var res = await http.get(
      Uri.parse('http://192.168.1.2/test/api/message/getMessages.php?id=1'),
    );
    var jsonResponse;

    if (res.statusCode == 200) {
      jsonResponse = jsonDecode(res.body);
      NotificationAPI.showNotification(
        title: 'Notification Title',
        body: 'Notification body',
        payload: 'Notification payload',
      );
    } else {
      print(res.body);
    }
    return Future.value(true);
  });
}
