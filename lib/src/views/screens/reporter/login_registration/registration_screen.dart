import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_gender_picker.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  final MainModel model;
  final GlobalKey<ScaffoldState> scaffold_key;

  RegistrationScreen({required this.model, required this.scaffold_key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _load = false;
  String pass = "";
  final _formKey = GlobalKey<FormState>();
  FocusNode bdayFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  TextEditingController bdateController = new TextEditingController();

  //user details
  String? first_name;
  String? last_name;
  String? sex = 'Male';
  String birthday = 'Birthdate';
  String? mobile_no;
  String? email;
  String? password;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final sexValidator = MultiValidator([
    RequiredValidator(errorText: 'Sex is required'),
  ]);

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character'),
  ]);

  final mobileNoValidator = MultiValidator([
    RequiredValidator(errorText: 'Mobile number is required.'),
    PhoneValidator(),
  ]);

  final birthdateValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    DateValidator('yyyy-MM-dd', errorText: 'Birthdate is required.'),
  ]);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        Widget loadingIndicator = _load
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
              //check if all fields are valid
              //if valid, save all field values
              //then store it inside a map
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();

                Map<String, dynamic> body = {
                  "first_name": first_name,
                  "last_name": last_name,
                  "mobile_no": mobile_no,
                  "email": email,
                  "password": password,
                  "password_confirmation": password,
                  "sex": sex,
                  "birthday": birthday,
                  "address": 'Sample Address',
                  "account_type": 'reporter',
                };

                print(body);

                String url = 'http://143.198.92.250/api/register';
                var jsonResponse;
                var res = await http.post(
                  Uri.parse(url),
                  body: body,
                );

                if (res.statusCode == 201) {
                  jsonResponse = jsonDecode(res.body);

                  if (jsonResponse != null) {
                    setState(() {
                      _load = true;
                    });

                    SharedPref preferences = SharedPref();
                    // save bearer token in the local storage
                    preferences.save("token", jsonResponse["token"]);

                    User user = User.fromMap(jsonResponse["user"]);

                    // save user credentials inside local storage
                    preferences.save("user", user);

                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/reporter/home',
                      (Route<dynamic> route) => false,
                      arguments: ScreenArguments(
                        user: user,
                      ),
                    );
                  }
                } else {
                  print(res.statusCode);
                }
              }
            },
          ),
        ],
      );

  Widget _buildTopContainer() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello!',
              style: DefaultTextTheme.headline2,
            ),
            Text(
              'Get emergency alerts by signing up.',
              style: DefaultTextTheme.subtitle1,
            ),
            const SizedBox(height: 20),
            // GoogleSignInButton(),
            // const SizedBox(height: 10),
            // FormDivider(),
            // const SizedBox(height: 10),
            FirstNameTextField(),
            const SizedBox(height: 10),
            LastNameTextField(),
            const SizedBox(height: 10),
            CustomGenderPicker(
              onChanged: (val) {
                sex = val;
              },
            ),
            const SizedBox(height: 10),
            BirthDatePicker(),
            const SizedBox(height: 10),
            MobileNoTextField(),
            const SizedBox(height: 10),
            EmailTextField(),
            const SizedBox(height: 10),
            PasswordTextField(),
            const SizedBox(height: 10),
            ConfirmPasswordTextField(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget FirstNameTextField() {
    return CustomTextFormField(
      validator: nameValidator,
      keyboardType: TextInputType.name,
      label: 'First Name',
      onSaved: (value) {
        if (value != null) first_name = value.trim();
      },
      prefixIcon: CustomIcons.person,
    );
  }

  Widget LastNameTextField() {
    return CustomTextFormField(
      validator: nameValidator,
      label: 'Last Name',
      onSaved: (value) {
        if (value != null) last_name = value.trim();
      },
      prefixIcon: CustomIcons.person,
      keyboardType: TextInputType.name,
    );
  }

  Widget GenderDropDown() {
    return CustomDropDownButton(
      hintText: 'Sex',
      icon: CustomIcons.sex,
      focusNode: bdayFocusNode,
      items: ['Male', 'Female'],
      onSaved: (val) {
        sex = val;
      },
      validator: (value) => value == null ? 'Sex is required' : null,
      isDisabled: false,
    );
  }

  Widget BirthDatePicker() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 3,
          child: CustomTextFormField(
            key: Key(birthday),
            controller: bdateController,
            label: 'Birthdate',
            keyboardType: TextInputType.datetime,
            isReadOnly: true,
            prefixIcon: CustomIcons.calendar,
            initialValue: birthday,
            onSaved: (newValue) {
              birthday = newValue!;
            },
            validator: birthdateValidator,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 80,
              height: 50,
              child: OutlinedButton(
                focusNode: bdayFocusNode,
                onPressed: () {
                  print(DateTime.now().year);
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime.now(),
                  ).then((d) {
                    setState(() {
                      if (d != null) {
                        DateTime date = d;
                        birthday = formatter.format(date);
                        bdateController.text = birthday;
                      }
                    });
                    mobileFocusNode.requestFocus();
                  });
                },
                child: Text('Set'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget MobileNoTextField() {
    return CustomTextFormField(
      validator: mobileNoValidator,
      label: 'Mobile Number',
      onSaved: (value) {
        mobile_no = value;
      },
      prefixIcon: CustomIcons.telephone,
      keyboardType: TextInputType.phone,
      focusNode: mobileFocusNode,
    );
  }

  Widget EmailTextField() {
    return CustomTextFormField(
      keyboardType: TextInputType.emailAddress,
      prefixIcon: CustomIcons.mail,
      validator: emailValidator,
      label: 'Email',
      onSaved: (value) {
        if (value != null) email = value.trim();
      },
    );
  }

  Widget PasswordTextField() {
    return CustomPasswordTextFormField(
      validator: passwordValidator,
      label: 'Password',
      prefixIcon: CustomIcons.lock,
      onChanged: (val) => pass = val,
      onSaved: (val) {
        password = val;
      },
    );
  }

  Widget ConfirmPasswordTextField() {
    return CustomPasswordTextFormField(
      validator: (val) => MatchValidator(errorText: 'Passwords do not match')
          .validateMatch(val, pass),
      prefixIcon: CustomIcons.lock,
      label: 'Confirm Password',
      onSaved: (val) {
        password = val;
      },
      onChanged: (val) {},
    );
  }

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

  Widget GoogleSignInButton() {
    return SizedBox(
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
          FontAwesomeIcons.google,
          size: 18,
        ),
        label: const Text('Sign up with Google'),
      ),
    );
  }
}
