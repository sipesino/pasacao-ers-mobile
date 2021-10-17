import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class ForgotPasswordMobileNo extends StatefulWidget {
  ForgotPasswordMobileNo({Key? key}) : super(key: key);

  @override
  _ForgotPasswordMobileNo createState() => _ForgotPasswordMobileNo();
}

class _ForgotPasswordMobileNo extends State<ForgotPasswordMobileNo> {
  final mobileNoValidator = MultiValidator([
    RequiredValidator(errorText: 'Mobile number is required.'),
    PhoneValidator(),
  ]);
  final _formKey = GlobalKey<FormState>();
  late String mobile_no;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
          child: SingleChildScrollView(
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
                Navigator.pushNamed(
                  context,
                  '/forgot_password/email/verification',
                  arguments: ScreenArguments(
                    verificationType: 'mobile number',
                  ),
                );
              }
            },
          ),
        ],
      );

  Widget _buildTopContainer() => Expanded(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Forgot Password?',
                style: DefaultTextTheme.headline2,
              ),
              Text(
                'Don\'t fret! Just type in your email and we will send you a code to reset your password.',
                style: DefaultTextTheme.subtitle1,
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextFormField(
                validator: mobileNoValidator,
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  mobile_no = value!;
                },
                label: 'Mobile Number',
                prefixIcon: CustomIcons.telephone,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                  child: Text('Try a different method'),
                  onPressed: () {
                    Navigator.popAndPushNamed(
                      context,
                      '/forgot_password/email',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
}
