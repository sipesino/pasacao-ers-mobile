import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';

class OperationCard extends StatelessWidget {
  final LocationInfo location;

  const OperationCard({Key? key, required this.location}) : super(key: key);

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
              'Vehicle Accident',
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
                      operation_id: '1',
                      report: IncidentReport(
                        incident_id: '1',
                        incident_type: 'Vehicle Accident',
                        sex: 'fEmale',
                        age: '78',
                        description: 'The quick brown fox',
                        victim_status: 'Unconscious',
                        landmark: '711',
                        longitude: location.longitude,
                        latitude: location.latitude,
                        name: 'Juan Tamad',
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
