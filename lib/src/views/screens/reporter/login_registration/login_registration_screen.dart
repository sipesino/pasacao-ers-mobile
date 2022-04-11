import 'package:flutter/material.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/views/screens/reporter/login_registration/reporter_login_screen.dart';
import 'package:pers/src/views/screens/reporter/login_registration/reporter_registration_screen.dart';
import 'package:pers/src/views/screens/responder/responder_login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
  bool isLoading = false;
  bool loginAsResponder = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: loginAsResponder ? 1 : 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: Colors.white,
            title: SizedBox(
              height: 40,
              width: loginAsResponder ? 90 : 180,
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
                  if (!loginAsResponder)
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
            return loginAsResponder
                ? ResponderLoginScreen()
                : TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      LoginScreen(
                        model: this.widget.model,
                        scaffold_key: _scaffoldKey,
                        isLoading: isLoading,
                      ),
                      if (!loginAsResponder)
                        RegistrationScreen(
                          model: this.widget.model,
                          scaffold_key: _scaffoldKey,
                        ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
