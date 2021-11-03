import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:pers/src/widgets/bottom_container.dart';

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
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();
                setState(() {
                  widget.isLoading = true;
                });
                Map<String, String> credentials = {
                  "email": email!,
                  "password": password!,
                };
                widget.model
                    .postAPICall(
                  'http://192.168.56.1/pers/api/user/authentication.php',
                  credentials,
                )
                    .then((value) {
                  var status_code = value["statuscode"];
                  if (status_code == 200) {
                    Map<String, String> id = {
                      "id": value["id"],
                    };
                    widget.model
                        .getAPICall(
                      'http://192.168.56.1/pers/api/user/getUser.php',
                      id,
                    )
                        .then((value) {
                      var status_code = value["statuscode"];
                      print(status_code);
                      print(value["user"]);
                      user = User.fromMap(value["user"]);

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/reporter/home',
                        (Route<dynamic> route) => false,
                        arguments: ScreenArguments(
                          user: user,
                        ),
                      );
                      setState(() {
                        widget.isLoading = false;
                      });
                    });
                  } else {
                    setState(() {
                      widget.isLoading = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: new Text(value["msg"]),
                        backgroundColor: Colors.red,
                        duration: new Duration(seconds: 5),
                      ),
                    );
                    print(value["msg"]);
                  }
                });
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
                style: DefaultTextTheme.headline1,
              ),
              Text(
                'Sign in to your account',
                style: DefaultTextTheme.subtitle1,
              ),
              const SizedBox(height: 50),
              EmailTextField(),
              const SizedBox(height: 20),
              PasswordTextField(),
              const SizedBox(height: 10),
              FormDivider(),
              const SizedBox(height: 10),
              SignInWithGoogle(),
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
        initialValue: 'admin@email.com',
      );

  Widget PasswordTextField() => CustomPasswordTextFormField(
        validator: passwordValidator,
        label: 'Password',
        prefixIcon: CustomIcons.lock,
        onChanged: (String value) {},
        onSaved: (value) {
          password = value;
        },
        initialValue: 'admin',
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
        child: const Text('Forgot password?'),
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/forgot_password/email',
          );
        },
      );
}
