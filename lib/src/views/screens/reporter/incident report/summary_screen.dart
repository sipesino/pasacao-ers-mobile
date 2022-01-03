import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_label.dart';
import 'package:http/http.dart' as http;

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: _buildTopContainer(args),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopContainer(ScreenArguments args) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Text(
              'Incident Report Summary',
              style: DefaultTextTheme.headline2,
            ),
            Text(
              'Please review all the information stated below',
              style: DefaultTextTheme.subtitle1,
            ),
            SizedBox(height: 20),
            CustomLabel(
              label: 'Incident Type',
              value: args.incident_report!.incident_type!,
            ),
            Wrap(
              children: [
                SizedBox(
                  width: 90,
                  child: CustomLabel(
                    label: 'Sex',
                    value: args.incident_report!.sex!,
                  ),
                ),
                SizedBox(width: 30),
                SizedBox(
                  child: CustomLabel(
                    label: 'Age',
                    value: args.incident_report!.age!,
                  ),
                ),
              ],
            ),
            CustomLabel(
              label: 'Victim Status',
              value: args.incident_report!.status!,
            ),
            CustomLabel(
              label: 'Description',
              value: args.incident_report!.description!,
            ),
            CustomLabel(
              label: 'Address',
              value: args.incident_report!.address!,
            ),
            CustomLabel(
              label: 'Landmark',
              value: args.incident_report!.landmark!,
            ),
            SizedBox(height: 10),
            args.incident_report!.incident_images != null &&
                    args.incident_report!.incident_images!.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Incident Images',
                        style: TextStyle(
                          fontSize: 14,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          clipBehavior: Clip.none,
                          children: List.generate(
                            args.incident_report!.incident_images!.length,
                            (index) {
                              return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: boxShadow),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(args.incident_report!
                                        .incident_images![index].path),
                                    width: 110,
                                    height: 110,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _submitReport(args.incident_report!);
                },
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
            SizedBox(height: 30),
          ],
        ),
      );

  _submitReport(IncidentReport report) async {
    Map<String, dynamic> body = {
      "incident_type": report.incident_type,
      "sex": report.sex,
      "age": report.age,
      "victim_status": report.status,
      "description": report.description,
      "account_id": report.account_id,
      // incident_images: incident_images,
      "location": report.address,
      // landmark: landmark,
    };

    print(body);

    // get bearer token from shared preferences
    SharedPref pref = new SharedPref();
    String token = await pref.read("token");
    print(token);

    String url = 'http://143.198.92.250/api/incidents';
    var jsonResponse;
    var res = await http.post(Uri.parse(url), body: body, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      jsonResponse = jsonDecode(res.body);

      if (jsonResponse != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/reporter/home', (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: new Text("Incident report submitted successfuly"),
            backgroundColor: Colors.green,
            duration: new Duration(seconds: 5),
          ),
        );
      }
    } else {
      print(res.statusCode);
    }
  }
}
