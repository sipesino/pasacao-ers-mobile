import 'package:flutter/material.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/views/screens/reporter/login_registration/reporter_login_screen.dart';
import 'package:pers/src/views/screens/reporter/login_registration/reporter_registration_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            backgroundColor: Colors.white,
            title: const SizedBox(
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 10,
                  top: 10,
                  bottom: 10,
                ),
                child: SizedBox(
                  width: 142,
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).popAndPushNamed(
                              '/responder/login',
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      primary: Colors.black,
                      side: const BorderSide(width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text('I\'m a responder'),
                  ),
                ),
              )
            ],
          ),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (context, child, MainModel model) {
            return Stack(
              children: <Widget>[
                TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    LoginScreen(
                      model: this.widget.model,
                      scaffold_key: _scaffoldKey,
                      isLoading: isLoading,
                    ),
                    RegistrationScreen(
                      model: this.widget.model,
                      scaffold_key: _scaffoldKey,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
