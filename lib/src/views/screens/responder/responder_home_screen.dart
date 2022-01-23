import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_card.dart';
import 'package:pers/src/widgets/operation_card.dart';

class ResponderHomeScreen extends StatelessWidget {
  const ResponderHomeScreen({Key? key}) : super(key: key);

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
            OperationCard(
              location: LocationInfo(
                location_id: 6,
                location_type: 'Hospital',
                address: 'Pasacao, Camarines Sur',
                longitude: '13.504323',
                latitude: '123.040576',
                location_name: 'Pasacao Rural Health Unit',
              ),
            ),
            displayNoOperationAssigned(),
            SizedBox(height: 20),
            Text(
              'Proceeding Incidents',
              style: DefaultTextTheme.headline5,
            ),
            SizedBox(height: 10),
            Column(
              children: [
                IncidentCard(),
                IncidentCard(),
                IncidentCard(),
                IncidentCard(),
              ],
            ),
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
