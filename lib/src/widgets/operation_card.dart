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
    return InkWell(
      splashColor: accentColor,
      splashFactory: InkSplash.splashFactory,
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        viewOperationDetails(context);
      },
      child: Card(
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
                  viewOperationDetails(context);
                },
                child: Text('View Details'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void viewOperationDetails(BuildContext context) {
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
            longitude: operation.report!.longitude,
            latitude: operation.report!.latitude,
            address: operation.report!.address,
          ),
        ),
      ),
    );
  }
}
