import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_label.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _load = false;

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Widget loadingIndicator = _load
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

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Form(
                        key: _formKey,
                        child: _buildColumn(args),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }

  Widget _buildColumn(ScreenArguments args) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(args),
          _buildBottomContainer(),
        ],
      );

  Widget _buildTopContainer(ScreenArguments args) => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Incident Report Summary',
                    style: DefaultTextTheme.headline2,
                  ),
                  Text(
                    'Please review all the information stated below',
                    style: DefaultTextTheme.subtitle1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomLabel(
                    label: 'Incident Type',
                    value: args.incident_report!.incident_type!,
                  ),
                  CustomLabel(
                    label: 'Patient Name',
                    value: args.incident_report!.patient_name!,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomLabel(
                          label: 'Sex',
                          value: args.incident_report!.sex!,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomLabel(
                          label: 'Age',
                          value: args.incident_report!.age!,
                        ),
                      ),
                    ],
                  ),
                  CustomLabel(
                    label: 'Description',
                    value: args.incident_report!.description!,
                  ),
                  CustomLabel(
                    label: 'Location',
                    value: args.incident_report!.location!,
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                              boxShadow: [
                                new BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  offset: new Offset(-10, 10),
                                  blurRadius: 20.0,
                                  spreadRadius: 4.0,
                                ),
                              ],
                            ),
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
              ),
            ),
          ),
        ),
      );

  Widget _buildBottomContainer() => Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(
                  'Back',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
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
      );
}
