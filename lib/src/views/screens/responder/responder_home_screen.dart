import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/fcm_service.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_card.dart';
import 'package:pers/src/widgets/operation_card.dart';

class ResponderHomeScreen extends StatefulWidget {
  const ResponderHomeScreen({Key? key}) : super(key: key);

  @override
  State<ResponderHomeScreen> createState() => _ResponderHomeScreenState();
}

class _ResponderHomeScreenState extends State<ResponderHomeScreen> {
  final Connectivity _connectivity = Connectivity();
  bool gotNewOperation = false;
  Operation? operation;

  @override
  void initState() {
    super.initState();
    _connectivity.checkConnectivity().then((status) {
      ConnectivityResult _connectionStatus = status;
      if (_connectionStatus != ConnectivityResult.none) {
        try {
          InternetAddress.lookup('example.com').then((value) {
            final result = value;

            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              print('connected');
              setupFcm((val) {
                setState(() {
                  try {
                    Map<String, dynamic> data = jsonDecode(val);

                    operation = Operation(
                      operation_id: data['operation_id'],
                      report: IncidentReport(
                        incident_id: data['incident_id'],
                        description: data['description'],
                        incident_type: data['incident_type'],
                        name: data['name'],
                      ),
                    );
                    print(operation.toString());
                  } catch (e) {
                    print(e);
                  }
                  gotNewOperation = true;
                });
              });
            }
          });
        } on SocketException catch (_) {
          print('not connected');
        }
      } else {
        print("No internet connection");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Incident Notification',
              style: DefaultTextTheme.headline4,
            ),
            SizedBox(height: 20),
            gotNewOperation
                ? OperationCard(
                    operation: operation!,
                  )
                : displayNoOperationAssigned(),
          ],
        ),
      ),
    );
  }

  Widget displayNoOperationAssigned() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: primaryColor,
        ),
      ),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
          boxShadow: boxShadow,
        ),
        child: Center(
          child: Text(
            'No operation assigned',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
