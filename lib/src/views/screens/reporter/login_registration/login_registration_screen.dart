import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:pers/src/globals.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/views/screens/reporter/login_registration/login_screen.dart';
import 'package:pers/src/views/screens/reporter/login_registration/registration_screen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:page_transition/page_transition.dart';

class LoginRegistrationScreen extends StatefulWidget {
  final MainModel model;

  LoginRegistrationScreen({required this.model});

  @override
  State<LoginRegistrationScreen> createState() =>
      _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends State<LoginRegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int screen_index = 0;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 3000,
      splash: 'assets/images/logo.png',
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: bgColor,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: AbsorbPointer(
        absorbing: isLoading,
        child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: AppBar(
                title: SizedBox(
                  height: 40,
                  width: 180,
                  child: TabBar(
                    indicatorColor: accentColor,
                    tabs: [
                      Tab(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: ScopedModelDescendant<MainModel>(
              builder: (context, child, MainModel model) {
                return TabBarView(
                  children: [
                    LoginScreen(
                      model: this.widget.model,
                      scaffold_key: _scaffoldKey,
                      notify_parent: refresh,
                    ),
                    RegistrationScreen(
                      model: this.widget.model,
                      scaffold_key: _scaffoldKey,
                      notify_parent: refresh,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  refresh() {
    setState(() {});
  }
}
