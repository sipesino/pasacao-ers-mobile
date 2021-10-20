import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:pers/src/widgets/custom_password_text_form_field.dart';

// ignore: must_be_immutable
class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({Key? key, required this.forgotPassword}) : super(key: key);

  bool forgotPassword;
  String pass = "";
  String? new_password;
  String? old_password;

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character'),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Back',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: buildColumn(),
            ),
          ),
        );
      }),
    );
  }

  Widget buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildTopContainer(),
        BottomContainer(
          onPressed: () async {
            if (this.forgotPassword) {
            } else {}
          },
        ),
      ],
    );
  }

  Widget buildTopContainer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create new password',
              style: DefaultTextTheme.headline2,
            ),
            Text(
              'Your new password should be different from your previous password',
              style: DefaultTextTheme.subtitle1,
            ),
            SizedBox(height: 30),
            this.forgotPassword
                ? SizedBox.shrink()
                : Column(
                    children: [
                      CustomPasswordTextFormField(
                        prefixIcon: CustomIcons.lock,
                        validator: passwordValidator,
                        label: 'Old Password',
                        onSaved: (val) {},
                        onChanged: (val) => old_password = val,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
            CustomPasswordTextFormField(
              prefixIcon: CustomIcons.lock,
              validator: passwordValidator,
              label: 'New Password',
              onSaved: (val) {},
              onChanged: (val) => pass = val,
            ),
            SizedBox(height: 20),
            CustomPasswordTextFormField(
              validator: (val) =>
                  MatchValidator(errorText: 'Passwords do not match')
                      .validateMatch(val, pass),
              prefixIcon: CustomIcons.lock,
              label: 'Confirm Password',
              onSaved: (val) {
                new_password = val;
              },
              onChanged: (val) {},
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
