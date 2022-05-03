import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:pers/main.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';

AudioPlayer? audioPlayer;

void playAlertSound() async {
  AudioCache cache = new AudioCache();
  audioPlayer = await cache.play("sounds/alert_sound.mp3");
}

void stopAlertSound() {
  if (audioPlayer != null) audioPlayer!.stop();
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  SharedPref().read('user').then((value) {
    user = User.fromJson(value);
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
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: user?.account_type!.toLowerCase() == 'reporter'
          ? ''
          : message.data['"operation"'],
    );
    playAlertSound();

    if (user!.account_type!.toLowerCase() != 'reporter') {
      saveOperation(message);
    }
    print('>>> Background notification received');
  });
  await Firebase.initializeApp();
}

void saveOperation(RemoteMessage message) {
  Map<String, dynamic> data = jsonDecode(message.data['"operation"']);
  final operation = Operation(
    operation_id: data['operation_id'],
    report: IncidentReport(
      incident_id: data['incident_id'],
      description: data['description'],
      incident_type: data['incident_type'],
      name: data['name'],
      sex: data['sex'],
      age: data['age'],
      victim_status: data['victim_status'],
      landmark: data['landmark'],
      latitude: data['latitude'].toString(),
      longitude: data['longitude'].toString(),
    ),
  );
  SharedPref().save('gotNewOperation', 'true');
  SharedPref().save('operation', operation);
  print('>> Operation saved');
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

void setupFcm(void Function(String) onNewOperation) {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOs = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOs,
  );

  //when the app is in foreground state and you click on notification.
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String? payload) {
    if (payload != null || payload!.isNotEmpty) {
      print('>>> Payload: $payload');
      Map<String, dynamic> data = json.decode(payload);
      goToNextScreen(data);
    }
  });

  //When the app is terminated, i.e., app is neither in foreground or background.
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    //Its compulsory to check if RemoteMessage instance is null or not.
    if (message != null) {
      print(message.data);
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
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: user!.account_type!.toLowerCase() == 'reporter'
            ? ''
            : message.data['"operation"'],
      );
      print('>>> Initial notification received');
      // goToNextScreen(message.data);
      if (user!.account_type!.toLowerCase() != 'reporter') {
        saveOperation(message);
        onNewOperation(message.data['"operation"']);
      }
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (user!.account_type!.toLowerCase() != 'reporter') {
      playAlertSound();
      saveOperation(message);
      onNewOperation(message.data['"operation"']);
    } else {
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
            icon: '@mipmap/ic_launcher',
          ),
        ),
        payload: user!.account_type!.toLowerCase() == 'reporter'
            ? ''
            : message.data['"operation"'],
      );
    }
    print('>>> Foreground notification received');
  });

  //When the app is in the background, but not terminated.
  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) {
      if (user!.account_type!.toLowerCase() != 'reporter') {
        print('>>> onMessageOpenedApp fired');
        onNewOperation(message.data['"operation"']);
        goToNextScreen(message.data['"operation"']);
      }
    },
    cancelOnError: false,
    onDone: () {},
  );
}

Future<void> deleteFcmToken() async {
  return await FirebaseMessaging.instance.deleteToken();
}

Future<String> getFcmToken() async {
  String? token = await FirebaseMessaging.instance.getToken();
  return Future.value(token);
}

void goToNextScreen(Map<String, dynamic>? data) {
  if (data != null) {
    Operation operation = Operation.fromMap(data);
    IncidentReport report = IncidentReport.fromMap(data);
    operation.report = report;

    print('>>> Report: $report');
    print('>>> Operation: $operation');
    navigatorKey.currentState?.pushNamed(
      '/responder/home/new_operation',
      arguments: ScreenArguments(
        operation: operation,
      ),
    );
    return;
  }
}

Future<String> _base64encodedImage(String url) async {
  final http.Response response = await http.get(Uri.parse(url));
  final String base64Data = base64Encode(response.bodyBytes);
  return base64Data;
}
