import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
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
                child: Expanded(
                  child: Column(
                    children: [
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                      EmergencyContactCard(
                        contact_name: 'Juan',
                        contact_number: '09296871657',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
