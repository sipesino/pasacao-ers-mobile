import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/add_contact_dialog.dart';

class EmergencyContactCard extends StatelessWidget {
  // final ImageProvider image;
  final String contact_name;
  final String contact_number;
  final String contact_image;

  const EmergencyContactCard({
    Key? key,
    required this.contact_name,
    required this.contact_number,
    this.contact_image = 'assets/images/avatar-image.png',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 160,
        height: 100,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              this.contact_name,
              style: DefaultTextTheme.headline5,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            Text(
              this.contact_number,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyContactCard2 extends StatelessWidget {
  final String contact_name;
  final String contact_number;
  final String contact_image;
  final int index;

  const EmergencyContactCard2({
    Key? key,
    required this.contact_name,
    required this.contact_number,
    this.contact_image = 'assets/images/avatar-image.png',
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Material(
        child: Container(
          width: double.infinity,
          height: 90,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: boxShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.contact_name,
                      style: DefaultTextTheme.headline4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                    Text(
                      this.contact_number,
                      style: DefaultTextTheme.subtitle2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: IconButton(
                  padding: new EdgeInsets.all(0.0),
                  onPressed: () {
                    showAddContactDialog(context);
                  },
                  icon: Container(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                    ),
                  ),
                  iconSize: 20,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(index);
        return AddContactDialog(
          editContact: true,
          contact_name: contact_name,
          contact_number: contact_number,
          contact_image: contact_image,
          index: index,
        );
      },
    );
  }
}
