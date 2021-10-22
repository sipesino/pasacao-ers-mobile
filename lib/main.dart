import 'package:flutter/material.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_email.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_mobile_no.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_verification_code.dart';
import 'package:pers/src/views/screens/forgot%20password/new_password_screen.dart';
import 'package:pers/src/views/screens/reporter/emergency_contacts_screen.dart';
import 'package:pers/src/views/screens/reporter/hotlines_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/description_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/location_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/summary_screen.dart';
import 'package:pers/src/views/screens/reporter/login_registration/login_registration_screen.dart';
import 'package:pers/src/views/screens/reporter/personal_info_screen.dart';
import 'package:pers/src/views/screens/reporter/reporter_main_screen.dart';
import 'package:pers/src/views/screens/responder/responder_login_screen.dart';
import 'package:pers/src/views/screens/responder/responder_main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MERS());
}

class MERS extends StatefulWidget {
  @override
  State<MERS> createState() => _MERSState();
}

class _MERSState extends State<MERS> {
  @override
  void initState() {
    super.initState();
    PermissionHandler.checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final MainModel _model = MainModel();
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        title: 'PERS',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => LoginRegistrationScreen(model: _model),
          '/reporter/home': (context) => ReporterMainScreen(),
          '/responder/home': (context) => ResponderMainScreen(),
          '/responder/login': (context) => ResponderLoginScreen(),
          '/forgot_password/email': (context) => ForgotPasswordEmail(),
          '/forgot_password/mobile_no': (context) => ForgotPasswordMobileNo(),
          '/forgot_password/email/verification': (context) =>
              ForgotPasswordVerification(),
          '/forgot_password/mobile_no/verification': (context) =>
              ForgotPasswordVerification(),
          '/forgot_password/mobile_no/verification/new_password': (context) =>
              NewPasswordScreen(forgotPassword: true),
          '/forgot_password/email/verification/new_password': (context) =>
              NewPasswordScreen(forgotPassword: true),
          '/reporter/home/report': (context) => ResponderMainScreen(),
          '/reporter/home/report/description': (context) => DescriptionScreen(),
          '/reporter/home/report/location': (context) => LocationScreen(),
          '/reporter/home/report/summary': (context) => SummaryScreen(),
          '/reporter/home/hotlines': (context) => HotlinesScreen(),
          '/reporter/home/emergency_contacts': (context) =>
              EmergencyContactsScreen(),
          '/reporter/home/profile': (context) => PersonalInformationScreen(),
          '/reporter/home/profile/new_password': (context) =>
              NewPasswordScreen(forgotPassword: false),
        },
        theme: lightThemeData(context),
      ),
    );
  }
}
