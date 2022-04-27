import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';

class IncidentCard extends StatelessWidget {
  const IncidentCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: boxShadow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Vehicle Accident',
                        style: DefaultTextTheme.headline5,
                      ),
                      SizedBox(width: 20),
                      Flexible(
                        child: Text(
                          '11-16-21, 5:17pm',
                          style: DefaultTextTheme.subtitle2,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '8741 Paseo de Roxas, Metro Manila, NCR, Philippines',
                          style: DefaultTextTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
