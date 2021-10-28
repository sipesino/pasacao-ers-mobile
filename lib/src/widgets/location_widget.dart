import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: new Offset(-10, 10),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pasacao Police Station',
                    style: DefaultTextTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Danao-Pasacao Road, Pasacao, Bicol Region, 4417',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '3km away',
                    style: DefaultTextTheme.subtitle2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            ClipOval(
              child: SizedBox(
                height: 40,
                width: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      accentColor,
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(0),
                    ),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
