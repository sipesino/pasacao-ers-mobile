import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:http/http.dart' as http;

class ResponderLoginScreen extends StatefulWidget {
  const ResponderLoginScreen({Key? key}) : super(key: key);

  @override
  State<ResponderLoginScreen> createState() => _ResponderLoginScreenState();
}

class _ResponderLoginScreenState extends State<ResponderLoginScreen>
    with WidgetsBindingObserver {
  String? email;
  String? password;

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
  ]);

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          )
        : new Container();

    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              const SizedBox(
                height: 40,
                width: 90,
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
                  ],
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: SizedBox(
                width: 142,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('/');
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black,
                    side: const BorderSide(width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text('I\'m a reporter'),
                ),
              ),
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Stack(
                    children: [
                      Form(
                        key: _formKey,
                        child: _buildColumn(),
                      ),
                      new Align(
                        child: loadingIndicator,
                        alignment: FractionalOffset.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(),
          BottomContainer(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                signIn();
              }
            },
          ),
        ],
      );

  Widget _buildTopContainer() => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Welcome!',
                style: DefaultTextTheme.headline2,
              ),
              Text(
                'Sign in to your account',
                style: DefaultTextTheme.subtitle1,
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextFormField(
                validator: emailValidator,
                keyboardType: TextInputType.emailAddress,
                label: 'Email',
                onSaved: (val) {
                  email = val;
                },
                initialValue: 'mrresponder@email.com',
                prefixIcon: CustomIcons.mail,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomPasswordTextFormField(
                validator: passwordValidator,
                label: 'Password',
                prefixIcon: CustomIcons.lock,
                initialValue: 'password!',
                onChanged: (String value) {},
                onSaved: (val) {
                  password = val;
                },
              ),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                child: const Text('Forgot password?'),
                onPressed: () {
                  Navigator.of(context).pushNamed('/forgot_password/email');
                },
              ),
            ],
          ),
        ),
      );

  signIn() async {
    String url = "http://143.198.92.250/api/login";
    Map body = {"email": email, "password": password};

    Map<String, dynamic> jsonResponse;
    var res;

    print(body);

    //check if there is internet connection
    if (await DataConnectionChecker().hasConnection) {
      res = await http.post(Uri.parse(url), body: body);

      //check if request is successfull
      if (res.statusCode == 201) {
        jsonResponse = jsonDecode(res.body);

        if (jsonResponse != null) {
          setState(() {
            isLoading = true;
          });

          if (jsonResponse["success"] &&
              jsonResponse["user"]["account_type"] == 'responder') {
            SharedPref preferences = SharedPref();
            // save bearer token in the local storage
            preferences.save("token", jsonResponse["token"]);

            User user = User.fromMap(jsonResponse["user"]);

            // save user credentials inside local storage
            preferences.save("user", user);

            setState(() {
              isLoading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/responder/home',
              (Route<dynamic> route) => false,
            );
            return;
          }
        }
      }
    }
    String message = "";
    if (!await DataConnectionChecker().hasConnection)
      message = "No internet. Check your internet connection";
    else if (res.statusCode == 401)
      message = "Invalid user credentials";
    else
      message = "Something went wrong.";

    setState(() {
      isLoading = false;
    });

    print(res.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: new Text(message),
        backgroundColor: Colors.red,
        duration: new Duration(seconds: 3),
      ),
    );
  }
}
