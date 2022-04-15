import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/globals.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  static const String idScreen = 'login';
  final MainModel model;
  final GlobalKey<ScaffoldState> scaffold_key;
  final Function() notify_parent;

  LoginScreen({
    Key? key,
    required this.model,
    required this.scaffold_key,
    required this.notify_parent,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late User user;
  String? email;
  String? password;
  String? fbToken;

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
  ]);

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
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

        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: _buildColumn(),
                  ),
                ),
              ),
            ),
            new Align(
              child: loadingIndicator,
              alignment: FractionalOffset.center,
            ),
          ],
        );
      },
    );
  }

  Widget _buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(),
          BottomContainer(
            displayHotlinesButton: true,
            onPressed: () {
              FocusScope.of(context).unfocus();
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
              const SizedBox(height: 50),
              EmailTextField(),
              const SizedBox(height: 20),
              PasswordTextField(),
              // const SizedBox(height: 10),
              // FormDivider(),
              // const SizedBox(height: 10),
              // SignInWithGoogle(),
              Flexible(
                flex: 1,
                child: SizedBox(
                  height: 70,
                ),
              ),
              // ForgotPassButton(),
            ],
          ),
        ),
      );

  Widget EmailTextField() => CustomTextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) {
          email = value;
        },
        label: 'Email',
        prefixIcon: CustomIcons.mail,
        validator: emailValidator,
        initialValue: 'jdlc@email.com',
      );

  Widget PasswordTextField() => CustomPasswordTextFormField(
        validator: passwordValidator,
        label: 'Password',
        prefixIcon: CustomIcons.lock,
        onChanged: (String value) {},
        onSaved: (value) {
          password = value;
        },
        initialValue: 'password!',
      );

  Widget FormDivider() => Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              thickness: 1,
              color: chromeColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("or"),
          ),
          Expanded(
            child: Divider(
              thickness: 1.5,
              color: chromeColor,
            ),
          ),
        ],
      );

  Widget SignInWithGoogle() => SizedBox(
        width: double.infinity,
        height: 60,
        child: OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            primary: Colors.black,
            side: const BorderSide(width: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          icon: const Icon(
            CustomIcons.google,
            size: 18,
          ),
          label: const Text('Sign in with Google'),
        ),
      );

  Widget ForgotPassButton() => TextButton(
        child: const Text(
          'Forgot password?',
          style: TextStyle(
            color: accentColor,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/forgot_password/email',
          );
        },
      );

  getToken() async {
    fbToken = await FirebaseMessaging.instance.getToken();
    // print('Firebase Token: $fbToken');
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  signIn() async {
    String message = "";
    final Connectivity _connectivity = Connectivity();

    //check if there is internet connection
    _connectivity.checkConnectivity().then((status) async {
      ConnectivityResult _connectionStatus = status;
      setState(() {
        isLoading = true;
      });

      widget.notify_parent();

      String url = "http://143.198.92.250/api/login";
      Map body = {"email": email, "password": password};

      Map<String, dynamic> jsonResponse;
      var res;
      if (_connectionStatus != ConnectivityResult.none && await hasNetwork()) {
        res = await http.post(Uri.parse(url), body: body).catchError((error) {
          print(error);
        });

        //check if request is successfull
        if (res != null && res.statusCode == 201) {
          jsonResponse = jsonDecode(res.body);

          //check if response body has data
          if (jsonResponse.isNotEmpty) {
            if (jsonResponse["success"]) {
              SharedPref preferences = SharedPref();
              // save bearer token in the local storage
              preferences.save("token", jsonResponse["token"]);

              User user = User.fromMap(jsonResponse["user"]);

              // save user credentials inside local storage
              preferences.save("user", user);

              if (user.account_type!.toUpperCase() == 'REPORTER') {
                setState(() {
                  isLoading = false;
                });
                widget.notify_parent();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/reporter/home',
                  (Route<dynamic> route) => false,
                );
                return;
              } else {
                url = 'http://143.198.92.250/api/register_token';
                body = {"account_id": user.id.toString(), "token": fbToken};

                print(body);
                print(fbToken);

                res = await http.post(
                  Uri.parse(url),
                  body: body,
                  headers: {
                    "Authorization": "Bearer ${jsonResponse['token']}",
                    "Connection": "Keep-Alive",
                    "Keep-Alive": "timeout=5, max=1000",
                  },
                ).catchError((error) {
                  print(error);
                });

                if (res != null && res.statusCode == 201) {
                  print(res.body);
                  setState(() {
                    isLoading = false;
                  });
                  print('>>> Token inserted');
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/responder/home',
                    (Route<dynamic> route) => false,
                  );
                  return;
                }
                print(res.statusCode);
                print(res.body);
              }
            }
          }
        }
        if (res.statusCode == 401) message = "Invalid user credentials";
      } else {
        print("No internet connection");
        message = "No internet. Check your internet connection";
      }

      setState(() {
        isLoading = false;
      });
      widget.notify_parent();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: new Text(message),
          backgroundColor: Colors.red,
          duration: new Duration(seconds: 3),
        ),
      );
    });
  }
}
