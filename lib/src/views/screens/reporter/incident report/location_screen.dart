import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      body: SafeArea(
        child: _buildColumn(args),
      ),
    );
  }

  Widget _buildColumn(ScreenArguments args) {
    return Column(
      children: [
        _buildTopContainer(),
        _buildBottomContainer(args),
      ],
    );
  }

  Widget _buildTopContainer() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Incident Location',
              style: DefaultTextTheme.headline3,
            ),
            Text(
              'Please indicate the location of the incident',
              style: DefaultTextTheme.subtitle1,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text('Get location automatically'),
                Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _switchValue
                  ? SizedBox.shrink()
                  : CustomTextFormField(
                      keyboardType: TextInputType.streetAddress,
                      prefixIcon: Icons.pin_drop_outlined,
                      label: 'Address',
                      onSaved: (val) {},
                    ),
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              keyboardType: TextInputType.streetAddress,
              prefixIcon: Icons.business_rounded,
              label: 'Landmark',
              onSaved: (val) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContainer(ScreenArguments args) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: OutlinedButton.icon(
                onPressed: () {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: primaryColor,
                ),
                label: Text(
                  'Back',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  var report = new IncidentReport(
                    patient_name: args.incident_report!.patient_name,
                    sex: args.incident_report!.sex,
                    incident_type: args.incident_report!.incident_type,
                    description: args.incident_report!.description,
                    age: args.incident_report!.age,
                    location: 'Sa gilid gilid lang. dyan lang sa harani',
                    incident_images: args.incident_report!.incident_images,
                  );

                  Navigator.of(context).pushNamed(
                    '/reporter/home/report/summary',
                    arguments: ScreenArguments(
                      incident_report: report,
                    ),
                  );
                },
                child: Text('Continue'),
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
      );
}
