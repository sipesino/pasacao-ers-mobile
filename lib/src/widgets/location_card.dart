import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  const LocationCard({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.location_name,
                    style: DefaultTextTheme.headline5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    location.address,
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
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/reporter/home/map',
                      arguments: ScreenArguments(
                        destination: location.coordinates,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
