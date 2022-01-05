import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/widgets/incident_card.dart';

class ResponderOperationsScreen extends StatelessWidget {
  const ResponderOperationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Incidents Responded',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
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
