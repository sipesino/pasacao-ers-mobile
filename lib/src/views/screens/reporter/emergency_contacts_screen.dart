import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/widgets/add_contact_dialog.dart';
import 'package:pers/src/widgets/emergency_contact_card.dart';

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({Key? key}) : super(key: key);

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
                  children: getEmergencyContacts().map((e) {
                    return EmergencyContactCard2(
                      contact_name: e.contact_name,
                      contact_number: e.contact_number,
                      contact_image: e.contact_image,
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
          showAddContactDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: accentColor,
      ),
    );
  }

  void showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddContactDialog();
      },
    );
  }
}