import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'firebase_options.dart';
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
import 'package:pers/src/views/screens/responder/operation/new_operation_screen.dart';
import 'package:pers/src/views/screens/responder/operation/proceeding_screen.dart';
import 'package:pers/src/views/screens/responder/responder_login_screen.dart';
import 'package:pers/src/views/screens/responder/responder_main_screen.dart';
import 'package:scoped_model/scoped_model.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('alert_sound'),
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['title'],
    message.data['body'],
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: 'channel description',
        color: Colors.blue,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('alert_sound'),
        icon: '@mipmap/ic_launcher',
      ),
    ),
    payload: message.data.toString(),
  );
  print("Data: ${message.data}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  SharedPref prefs = SharedPref();
  String data = await prefs.read('user');
  User? user;
  if (data != 'null') user = User.fromJson(await data);
  Paint.enableDithering = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var token = await FirebaseMessaging.instance.getToken();
  print('token: $token');

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  _connectionStatus = await _connectivity.checkConnectivity();

  print(_connectionStatus);
  if (_connectionStatus != ConnectivityResult.none) {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }

      print('1');
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        flutterLocalNotificationsPlugin.show(
          message.hashCode,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: 'channel description',
              color: Colors.blue,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('alert_sound'),
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data.toString(),
        );
        // print("Data: ${message.data}");
      });
    } on SocketException catch (_) {
      print('not connected');
    }
  } else {
    print("No internet connection");
  }

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
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // Navigator.pushNamed(
    //   context,
    //   '/responder/home/new_operation',
    //   arguments: ScreenArguments(
    //     latitude: location.latitude,
    //     longitude: location.longitude,
    //   ),
    // );
    print('\n\n>>> i click bacasdasd\n\n');
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
          '/responder/home/proceeding_operation': (context) =>
              ProceedingScreen(),
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
