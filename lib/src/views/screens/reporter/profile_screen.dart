import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/emergency_contact_card.dart';

class ProfileScreen extends StatefulWidget {
  final bool isResponder;

  ProfileScreen({
    this.isResponder = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true;
  List<EmergencyContact> contacts = [];

  @override
  void initState() {
    super.initState();
    SharedPref().read('user').then((value) {
      user = User.fromJson(value);
      setState(() {
        isLoading = false;
      });
    });
    SharedPref().read('contacts').then((value) {
      print(value);
      if (value != 'null')
        setState(() {
          contacts = EmergencyContact.decode(value);
        });
    });
  }

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
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildColumn(),
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
              "${user!.first_name} ${user!.last_name}",
              style: DefaultTextTheme.headline3,
            ),
            Text(
              user!.email ?? 'undefined',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            if (!widget.isResponder)
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
                      children: contacts.map((e) {
                        return EmergencyContactCard(
                          contact_name: e.contact_name,
                          contact_number: e.contact_number,
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
          if (user!.account_type! != 'external agency')
            buildPersonalInfoButton(),
          // buildIncidentsReportedButton(),
          // buildSettingsButton(),
          // buildAboutButton(),
          TextButton.icon(
            onPressed: () {
              logout(context);
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

  Future<dynamic> logout(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                SharedPref().clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: Text(
                'YES',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildPersonalInfoButton() {
    return TextButton.icon(
      onPressed: () async {
        final result =
            await Navigator.of(context).pushNamed('/reporter/home/profile');
        if (result != null) {
          SharedPref().reload();
          setState(() {
            user = result as User;
          });
        }
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
    );
  }
}

class buildAboutButton extends StatelessWidget {
  const buildAboutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
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
    );
  }
}

class buildSettingsButton extends StatelessWidget {
  const buildSettingsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
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
    );
  }
}

class buildIncidentsReportedButton extends StatelessWidget {
  const buildIncidentsReportedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
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
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
