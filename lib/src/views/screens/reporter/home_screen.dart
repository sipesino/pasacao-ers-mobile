import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/incident_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    SharedPref().reload();
    SharedPref().read('user').then((value) {
      setState(() {
        user = User.fromJson(value);
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              children: [
                SizedBox(height: 30),
                Text(
                  'Hey ${user!.first_name ?? ''}!',
                  style: DefaultTextTheme.headline3,
                ),
                Text(
                  'We are here for you.',
                  style: DefaultTextTheme.subtitle2,
                ),
                SizedBox(height: 20),
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
                  height: 75.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: boxShadow,
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
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: incident_types.length,
                  itemBuilder: (context, index) {
                    return IncidentButton(
                      icon: incident_types[index].icon,
                      label: incident_types[index].label,
                      gradient: incident_types[index].gradient,
                      onPressed: () {
                        navigateToIncidentReportScreen(
                          context,
                          FontAwesomeIcons.carCrash,
                          incident_types[index].label,
                        );
                      },
                    );
                  },
                )
              ],
            ),
    );
  }

  final ButtonStyle elivatedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  navigateToIncidentReportScreen(
    BuildContext context,
    IconData icon,
    String incidentType,
  ) async {
    PermissionHandler.checkLocationPermission();

    Navigator.of(context).pushNamed(
      '/reporter/home/report',
      arguments: ScreenArguments(
        incidentType: incidentType,
      ),
    );
  }

  getUserCredentials() {}
}
