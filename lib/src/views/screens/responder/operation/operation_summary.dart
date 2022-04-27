import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/theme.dart';
import 'package:http/http.dart' as http;

class OperationSummaryScreen extends StatefulWidget {
  OperationSummaryScreen({Key? key}) : super(key: key);

  @override
  State<OperationSummaryScreen> createState() => _OperationSummaryScreenState();
}

class _OperationSummaryScreenState extends State<OperationSummaryScreen> {
  Operation? operation;

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  ScreenArguments? args;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    if (args!.operation != null) operation = args!.operation;

    Widget loadingIndicator = isLoading
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
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20.0),
            clipBehavior: Clip.none,
            children: <Widget>[
              Text(
                'Operation Report Summary',
                style: DefaultTextTheme.headline2,
              ),
              Text(
                'Please review all the information stated below',
                style: DefaultTextTheme.subtitle1,
              ),
              SizedBox(height: 20),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Personal Information'),
                children: <Widget>[
                  buildOperationDetail(
                    field: 'Name',
                    value: operation!.report!.name!,
                  ),
                  buildOperationDetail(
                    field: 'Sex',
                    value: operation!.report!.sex!,
                  ),
                  buildOperationDetail(
                    field: 'Age',
                    value: operation!.report!.age!,
                  ),
                  buildOperationDetail(
                    field: 'Address',
                    value: operation!.report!.permanent_address!,
                  ),
                  SizedBox(height: 10),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Vital Signs'),
                children: <Widget>[
                  buildOperationDetail(
                    field: 'Temperature',
                    value: '${operation!.report!.temperature!} °C',
                  ),
                  buildOperationDetail(
                    field: 'Pulse Rate',
                    value: '${operation!.report!.pulse_rate!} BPM',
                  ),
                  buildOperationDetail(
                    field: 'Respiration Rate',
                    value: '${operation!.report!.respiration_rate!} BPM',
                  ),
                  buildOperationDetail(
                    field: 'Blood Pressure',
                    value: '${operation!.report!.blood_pressure!}',
                  ),
                  SizedBox(height: 10),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Incident Information'),
                children: <Widget>[
                  buildOperationDetail(
                    field: 'Incident Type',
                    value: operation!.report!.incident_type!,
                  ),
                  buildOperationDetail(
                    field: 'Description',
                    value: operation!.report!.description!,
                  ),
                  buildOperationDetail(
                    field: 'Address',
                    value: 'operation!.report!.address!',
                  ),
                  buildOperationDetail(
                    field: 'Coordinates',
                    value:
                        '${operation!.report!.latitude!}, ${operation!.report!.longitude!}',
                  ),
                  buildOperationDetail(
                    field: 'Landmark',
                    value: 'operation!.report!.landmark!',
                  ),
                  SizedBox(height: 10),
                ],
              ),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: Text('Other Information'),
                children: <Widget>[
                  buildOperationDetail(
                    field: 'ETD Base',
                    value: operation!.etd_base!,
                  ),
                  buildOperationDetail(
                    field: 'ETA Scene',
                    value: operation!.eta_scene!,
                  ),
                  buildOperationDetail(
                    field: 'ETD Scene',
                    value: operation!.etd_scene!,
                  ),
                  buildOperationDetail(
                    field: 'ETA Hospital',
                    value: operation!.eta_hospital!,
                  ),
                  buildOperationDetail(
                    field: 'ETD Hospital',
                    value: operation!.etd_hospital!,
                  ),
                  buildOperationDetail(
                    field: 'ETA Base',
                    value: operation!.etd_base!,
                  ),
                  buildOperationDetail(
                    field: 'Receiving Facility',
                    value: operation!.receiving_facility!,
                  ),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: submitOperationReport,
                  child: Text('Submit Report'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(accentColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: loadingIndicator,
          ),
        ],
      ),
    );
  }

  Widget buildOperationDetail({required String field, required String value}) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            SizedBox(
              width: 95,
              child: Text(
                field,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: boxShadow,
                ),
                child: Text(
                  value,
                  style: DefaultTextTheme.headline5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  void submitOperationReport() {
    final Connectivity _connectivity = Connectivity();

    _connectivity.checkConnectivity().then((status) async {
      ConnectivityResult _connectionStatus = status;
      setState(() {
        isLoading = true;
      });
      if (_connectionStatus != ConnectivityResult.none) {
        SharedPref pref = new SharedPref();
        String token = await pref.read("token");

        String url =
            'http://143.198.92.250/api/incidents/${operation!.report!.incident_id}';
        print(url);
        Map<String, dynamic> body = {
          "name": operation!.report!.name,
          "sex": operation!.report!.sex!.toLowerCase(),
          "age": operation!.report!.age,
          "permanent_address": operation!.report!.age,
          "incident_status": "Completed",
          "temperature": operation!.report!.temperature,
          "pulse_rate": operation!.report!.pulse_rate,
          "respiration_rate": operation!.report!.respiration_rate,
          "blood_pressure": operation!.report!.blood_pressure,
        };

        print(body);

        var res = await http.put(
          Uri.parse(url),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (res.statusCode == 200) {
          String url =
              'http://143.198.92.250/api/operations/${operation!.operation_id}';
          print(url);

          Map<String, dynamic> body = {
            "etd_base": operation!.etd_base,
            "eta_scene": operation!.eta_scene,
            "etd_scene": operation!.etd_scene,
            "eta_hospital": operation!.eta_hospital,
            "etd_hospital": operation!.etd_hospital,
            "eta_base": operation!.eta_base,
            "receiving_facility": operation!.receiving_facility,
          };

          print(body);

          var res = await http.put(
            Uri.parse(url),
            body: body,
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (res.statusCode == 200) {
            setState(() {
              isLoading = false;
            });

            pref.remove('operation');
            pref.save('gotNewOperation', 'false');
            SharedPref().reload();
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/responder/home',
              (Route<dynamic> route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                content: new Text("Operation Report submitted successfuly."),
                backgroundColor: Colors.green,
                duration: new Duration(seconds: 5),
              ),
            );
          } else {
            //display error message
          }
        } else {
          //display error message
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: new Text("No internet connection."),
            backgroundColor: Colors.red,
            duration: new Duration(seconds: 5),
          ),
        );
      }
    });
  }
}
