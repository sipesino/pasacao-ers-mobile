import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_button.dart';

class HomeScreen extends StatelessWidget {
  final ScreenArguments args;
  final ScrollController controller;

  HomeScreen({
    Key? key,
    required this.args,
    required this.controller,
  }) : super(key: key);

  final ButtonStyle elivatedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        controller: controller,
        clipBehavior: Clip.none,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  'Hey ${args.user!.first_name}!\nwe\'re here for you.',
                  style: DefaultTextTheme.headline3,
                ),
                SizedBox(height: 30),
                Text(
                  'Call directly using Hotline',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        offset: new Offset(-10, 10),
                        blurRadius: 20.0,
                        spreadRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Material(
                    // elevation: 5,
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/reporter/home/hotlines',
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            FontAwesomeIcons.phone,
                            size: 30,
                          ),
                          SizedBox(
                            width: 170,
                            child: Text(
                              'Emergency Hotlines',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            CustomIcons.right_arrow,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Send Incident Report',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 15),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF51ABF7),
                      Color(0xFF5168FF),
                    ],
                  ),
                  icon: CustomIcons.cross,
                  label: 'Medical Emergency',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      CustomIcons.cross,
                      'Medical Emergency',
                    );
                  },
                ),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xff6685FC),
                      Color(0xFF9665FA),
                    ],
                  ),
                  icon: FontAwesomeIcons.carCrash,
                  label: 'Vehicle Accident',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      FontAwesomeIcons.carCrash,
                      'Vehicle Accident',
                    );
                  },
                ),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFEF60A3),
                      Color(0xFF9665FA),
                    ],
                  ),
                  icon: CustomIcons.criminal,
                  label: 'Theft or Roberry',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      CustomIcons.criminal,
                      'Theft or Roberry',
                    );
                  },
                ),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFdb7f8e),
                      Color(0xFFaa4465),
                    ],
                  ),
                  icon: FontAwesomeIcons.fistRaised,
                  label: 'Assault',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      FontAwesomeIcons.fistRaised,
                      'Assault',
                    );
                  },
                ),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFFFC9842),
                      Color(0xFFFE5F75),
                    ],
                  ),
                  icon: CustomIcons.fire,
                  label: 'Fire Incident',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      CustomIcons.fire,
                      'Fire Incident',
                    );
                  },
                ),
                IncidentButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF35E688),
                      Color(0xFF64A3E0),
                    ],
                  ),
                  icon: CustomIcons.drowning,
                  label: 'Drowning',
                  onPressed: () {
                    navigateToIncidentReportScreen(
                      context,
                      CustomIcons.drowning,
                      'Drowning Incident',
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  navigateToIncidentReportScreen(
    BuildContext context,
    IconData icon,
    String incidentType,
  ) async {
    PermissionHandler.checkLocationPermission();
    Location location = new Location();

    Navigator.of(context).pushNamed(
      '/reporter/home/report/description',
      arguments: ScreenArguments(
        incidentType: incidentType,
        user: args.user,
        icon: icon,
        location: location,
      ),
    );
  }
}
