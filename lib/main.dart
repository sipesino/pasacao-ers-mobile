import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/scoped_model/main_scoped_model.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_email.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_mobile_no.dart';
import 'package:pers/src/views/screens/Forgot%20Password/forgot_pass_verification_code.dart';
import 'package:pers/src/views/screens/forgot%20password/new_password_screen.dart';
import 'package:pers/src/views/screens/reporter/emergency_contacts_screen.dart';
import 'package:pers/src/views/screens/reporter/hotlines_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/incident_report_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/summary_screen.dart';
import 'package:pers/src/views/screens/reporter/login_registration/login_registration_screen.dart';
import 'package:pers/src/views/screens/reporter/map_screen.dart';
import 'package:pers/src/views/screens/reporter/personal_info_screen.dart';
import 'package:pers/src/views/screens/reporter/reporter_main_screen.dart';
import 'package:pers/src/views/screens/responder/new_operation_screen.dart';
import 'package:pers/src/views/screens/responder/responder_login_screen.dart';
import 'package:pers/src/views/screens/responder/responder_main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPref prefs = SharedPref();
  String data = await prefs.read('user');
  User? user;

  if (data != 'null') user = User.fromJson(await data);

  Paint.enableDithering = true;
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var token = await FirebaseMessaging.instance.getToken();

  print('token: $token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification!;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: 'channel description',
            color: Colors.blue,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: message.data.toString(),
      );
    }
  });

  runApp(MERS(initialRoute: user != null ? '/${user.account_type}/home' : '/'));
}

class MERS extends StatefulWidget {
  final String initialRoute;

  const MERS({Key? key, required this.initialRoute}) : super(key: key);
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
        initialRoute: widget.initialRoute,
        routes: {
          '/': (context) => LoginRegistrationScreen(model: _model),
          '/reporter/home': (context) => ReporterMainScreen(),
          '/responder/home': (context) => ResponderMainScreen(),
          '/responder/home/new_operation': (context) => NewOperation(),
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
          '/reporter/home/report': (context) => IncidentReportScreen(),
          '/reporter/home/report/summary': (context) => SummaryScreen(),
          '/reporter/home/hotlines': (context) => HotlinesScreen(),
          '/reporter/home/map': (context) => MapScreen(),
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
