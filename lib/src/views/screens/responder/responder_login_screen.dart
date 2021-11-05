import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:pers/src/widgets/bottom_container.dart';

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

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
  ]);

  @override
  Widget build(BuildContext context) {
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
                  child: Form(
                    key: _formKey,
                    child: _buildColumn(),
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
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/responder/home',
                  (Route<dynamic> route) => false,
                );
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
                prefixIcon: CustomIcons.mail,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomPasswordTextFormField(
                validator: passwordValidator,
                label: 'Password',
                prefixIcon: CustomIcons.lock,
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
}
