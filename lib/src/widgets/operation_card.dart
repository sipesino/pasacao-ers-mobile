import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';

class OperationCard extends StatelessWidget {
  final Operation operation;

  const OperationCard({
    Key? key,
    required this.operation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          color: Colors.white,
          boxShadow: boxShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CustomIcons.siren,
              size: 80,
              color: accentColor,
            ),
            SizedBox(height: 5),
            Text('New Operation!'),
            SizedBox(height: 5),
            Text(
              operation.report!.incident_type!,
              style: DefaultTextTheme.headline3,
            ),
            Text(
              '107 Katipunan Road, Quezon City',
              style: DefaultTextTheme.subtitle2,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/responder/home/new_operation',
                  arguments: ScreenArguments(
                    operation: Operation(
                      operation_id: operation.operation_id,
                      report: IncidentReport(
                        incident_id: operation.report!.incident_id,
                        incident_type: operation.report!.incident_type,
                        sex: operation.report!.sex,
                        age: operation.report!.age,
                        description: operation.report!.description,
                        victim_status: operation.report!.victim_status,
                        landmark: operation.report!.landmark,
                        name: operation.report!.name,
                        longitude: '122.9915123481884',
                        latitude: '13.551874638206568',
                        address: operation.report!.address,
                      ),
                    ),
                  ),
                );
              },
              child: Text('View Details'),
            )
          ],
        ),
      ),
    );
  }
}
