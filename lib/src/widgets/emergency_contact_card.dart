import 'package:flutter/material.dart';
import 'package:pers/src/theme.dart';

class EmergencyContact extends StatelessWidget {
  // final ImageProvider image;
  final String contact_name;
  final String contact_number;

  const EmergencyContact({
    Key? key,
    required this.contact_name,
    required this.contact_number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 15),
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: new Offset(-10, 10),
              blurRadius: 20.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0), //or 15.0
              child: Container(
                height: 50.0,
                width: 50.0,
                color: Color(0xffFF0E58),
                child: SizedBox.shrink(),
              ),
            ),
            SizedBox(height: 10),
            Text(
              this.contact_name,
              style: DefaultTextTheme.headline4,
            ),
            Text(
              this.contact_number,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmergencyContactCard extends StatelessWidget {
  final String contact_name;
  final String contact_number;

  const EmergencyContactCard({
    Key? key,
    required this.contact_name,
    required this.contact_number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Material(
        child: Container(
          width: double.infinity,
          height: 150,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: new Offset(-10, 10),
                blurRadius: 20.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: CircleAvatar(),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        this.contact_name,
                        style: DefaultTextTheme.headline3,
                      ),
                      Text(
                        this.contact_number,
                        style: DefaultTextTheme.subtitle2,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 20,
                height: 20,
                child: IconButton(
                  padding: new EdgeInsets.all(0.0),
                  onPressed: () {},
                  icon: Container(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
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
}
