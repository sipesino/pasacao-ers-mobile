import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/fcm_service.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/operation_card.dart';

class ResponderHomeScreen extends StatefulWidget {
  const ResponderHomeScreen({Key? key}) : super(key: key);

  @override
  State<ResponderHomeScreen> createState() => _ResponderHomeScreenState();
}

class _ResponderHomeScreenState extends State<ResponderHomeScreen> {
  final Connectivity _connectivity = Connectivity();
  bool? gotNewOperation;
  Operation? operation;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    SharedPref pref = SharedPref();

    pref.read('user').then((value) {
      user = User.fromJson(value);
    });

    pref
        .read('gotNewOperation')
        .then((value) => gotNewOperation = value.toLowerCase() == 'true');

    pref.read('operation').then((value) {
      if (value != 'null' && value.isNotEmpty) {
        Map<String, dynamic> operation_data = jsonDecode(value);
        operation = Operation(
          operation_id: operation_data['operation_id'],
          external_agency_id: operation_data['external_agency_id'],
          dispatcher_id: operation_data['dispatcher_id'],
          etd_base: operation_data['etd_base'],
          eta_scene: operation_data['eta_scene'],
          etd_scene: operation_data['etd_scene'],
          eta_hospital: operation_data['eta_hospital'],
          etd_hospital: operation_data['etd_hospital'],
          eta_base: operation_data['eta_base'],
          receivingFacility: operation_data['receivingFacility'],
        );
        Map<String, dynamic> report_data = jsonDecode(operation_data['report']);
        final report = IncidentReport(
          incident_id: report_data['incident_id'],
          description: report_data['description'],
          incident_type: report_data['incident_type'],
          name: report_data['name'],
          sex: report_data['sex'],
          age: report_data['age'],
          victim_status: report_data['victim_status'],
          landmark: report_data['landmark'],
          latitude: report_data['latitude'],
          longitude: report_data['longitude'],
        );
        operation!.report = report;
      }
    });

    _connectivity.checkConnectivity().then((status) {
      ConnectivityResult _connectionStatus = status;
      if (_connectionStatus != ConnectivityResult.none) {
        try {
          InternetAddress.lookup('example.com').then((value) {
            final result = value;

            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
                        sex: data['sex'],
                        age: data['age'],
                        victim_status: data['victim_status'],
                        landmark: data['landmark'],
                        latitude: data['latitude'].toString(),
                        longitude: data['longitude'].toString(),
                      ),
                    );
                    gotNewOperation = true;
                  } catch (e) {
                    print(e);
                  }
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
            if (user != null)
              Text(
                'Hi ${user!.first_name}!',
                style: DefaultTextTheme.headline4,
              ),
            Text(
              'Are you ready to respond?',
              style: DefaultTextTheme.subtitle2,
            ),
            SizedBox(height: 20),
            gotNewOperation ?? false
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
      ),
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
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
