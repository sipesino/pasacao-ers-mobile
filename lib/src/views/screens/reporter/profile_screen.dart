import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildColumn(),
            ),
          ),
        ),
      );
    });
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
            SizedBox(
              width: 120,
              height: 120,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://bit.ly/3lD1cKX',
                ),
                backgroundColor: Colors.transparent,
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
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    EmergencyContact(
                      contact_name: 'Mom',
                      contact_number: '09123456789',
                    ),
                    EmergencyContact(
                      contact_name: 'Dad',
                      contact_number: '09123456789',
                    ),
                    EmergencyContact(
                      contact_name: 'Brother',
                      contact_number: '09123456789',
                    ),
                    EmergencyContact(
                      contact_name: 'Sister',
                      contact_number: '09123456789',
                    ),
                    EmergencyContact(
                      contact_name: 'Uncle',
                      contact_number: '09123456789',
                    ),
                    EmergencyContact(
                      contact_name: 'Aunt',
                      contact_number: '09123456789',
                    ),
                  ],
                ),
              ),
            ],
          ),
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
