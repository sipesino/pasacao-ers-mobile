import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/emergency_contact_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.args}) : super(key: key);
  final ScreenArguments args;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: _buildColumn(),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(),
          _buildBottomContainer(),
        ],
      );

  Widget _buildTopContainer() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                color: chromeColor.withOpacity(0.5),
                border: Border.all(width: 5, color: Colors.white),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: boxShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image(
                  image: AssetImage('assets/images/avatar-image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            Text(
              'Juan Dela Cruz',
              style: DefaultTextTheme.headline3,
            ),
            Text(
              'juandelacruz@gmail.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed('/reporter/home/emergency_contacts');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: TextStyle(color: primaryColor),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18,
                        color: primaryColor,
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: getEmergencyContacts().map((e) {
                      return EmergencyContactCard(
                        contact_name: e.contact_name,
                        contact_number: e.contact_number,
                        contact_image: e.contact_image,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContainer() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed('/reporter/home/profile');
            },
            label: Text(
              'Personal Information',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            icon: Icon(
              CustomIcons.person,
              color: accentColor,
              size: 20,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              'Incidents Reported',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            icon: Icon(
              CustomIcons.siren,
              color: accentColor,
              size: 20,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              'Settings',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            icon: Icon(
              CustomIcons.settings,
              color: accentColor,
              size: 20,
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            label: Text(
              'About',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            icon: Icon(
              CustomIcons.about,
              color: accentColor,
              size: 20,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).popAndPushNamed('/');
            },
            label: Text(
              'Logout',
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            icon: Icon(
              CustomIcons.logout,
              color: accentColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
