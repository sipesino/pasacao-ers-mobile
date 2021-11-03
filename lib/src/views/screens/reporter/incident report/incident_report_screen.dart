import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/description_screen.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({Key? key}) : super(key: key);

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  int activeStep = 0;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Incident Report'),
        ),
        body: Stepper(steps: [
          Step(
            title: Text('Description'),
            content: DescriptionScreen(),
          ),
        ]));
  }
}
