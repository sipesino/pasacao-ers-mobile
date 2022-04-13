import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/widgets/add_contact_dialog.dart';
import 'package:pers/src/widgets/emergency_contact_card.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  List<EmergencyContact> contacts = [];

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Contacts',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: contacts.map((e) {
                    return EmergencyContactCard2(
                      contact_name: e.contact_name,
                      contact_number: e.contact_number,
                      index: contacts.indexOf(e),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showAddContactDialog(context);
          });
        },
        child: Icon(Icons.add),
        backgroundColor: accentColor,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }

  void showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddContactDialog(
          notify_parent: refresh,
        );
      },
    );
  }
}
