import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_card.dart';

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
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: accentColor.withOpacity(0.1),
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
}
