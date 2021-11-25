import 'package:flutter/material.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_card.dart';

class ResponderOperationsScreen extends StatelessWidget {
  const ResponderOperationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        child: Column(
          children: [
            Text(
              'Incidents Responded',
              style: DefaultTextTheme.headline4,
            ),
            SizedBox(height: 20),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
            IncidentCard(),
          ],
        ),
      ),
    );
  }
}
