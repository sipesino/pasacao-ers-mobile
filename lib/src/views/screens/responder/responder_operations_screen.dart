import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/widgets/incident_card.dart';

class ResponderOperationsScreen extends StatelessWidget {
  const ResponderOperationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            leading: Icon(
              CustomIcons.siren_2,
              color: accentColor,
            ),
            titleSpacing: 0,
            title: Text(
              'Operations Responded',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Padding(
            padding: EdgeInsets.all(20),
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
      ),
    );
  }
}
