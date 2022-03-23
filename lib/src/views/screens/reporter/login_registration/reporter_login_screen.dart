import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
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
  bool? isLoading;

  LoginScreen({
    Key? key,
    required this.model,
    required this.scaffold_key,
    this.isLoading,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late User user;
  String? email;
  String? password;

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
  ]);

  signIn() async {
    String url = "http://143.198.92.250/api/login";
    Map body = {"email": email, "password": password};

    Map<String, dynamic> jsonResponse;
    var res;

    //check if there is internet connection
    if (await DataConnectionChecker().hasConnection) {
      res = await http.post(Uri.parse(url), body: body);

      //check if request is successfull
      if (res.statusCode == 201) {
        jsonResponse = jsonDecode(res.body);

        //check if response body has data
        if (jsonResponse != null) {
          setState(() {
            widget.isLoading = true;
          });

          if (jsonResponse["success"]) {
            SharedPref preferences = SharedPref();
            // save bearer token in the local storage
            preferences.save("token", jsonResponse["token"]);

            User user = User.fromMap(jsonResponse["user"]);

            // save user credentials inside local storage
            preferences.save("user", user);

            setState(() {
              widget.isLoading = false;
            });

            Navigator.pushNamedAndRemoveUntil(
              context,
              '/reporter/home',
              (Route<dynamic> route) => false,
            );
          }
        }
        return;
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
      widget.isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: new Text(message),
        backgroundColor: Colors.red,
        duration: new Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        Widget loadingIndicator = widget.isLoading!
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
                  height: 20,
                ),
              ),
              ForgotPassButton(),
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
}
