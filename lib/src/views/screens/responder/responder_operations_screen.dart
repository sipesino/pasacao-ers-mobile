import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/widgets/incident_card.dart';

class ResponderOperationsScreen extends StatelessWidget {
  const ResponderOperationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              CustomIcons.siren_2,
              color: accentColor,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Operations Responded',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Column(
            children: [
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
      ),
    );
  }
}
