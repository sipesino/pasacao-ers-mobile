import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/location_card.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            automaticallyImplyLeading: false,
            toolbarHeight: 65,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Locations',
                          style: DefaultTextTheme.headline4,
                        ),
                        Text(
                          'List of emergency services locations',
                          style: DefaultTextTheme.subtitle1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/reporter/home/map',
                          arguments: ScreenArguments(
                            latitude: null,
                            longitude: null,
                          ),
                        );
                      },
                      child: Icon(
                        CustomIcons.map,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(accentColor),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: _buildColumn(),
          ),
        ),
      ),
    );
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: getLocations()
              .map(
                (e) => LocationCard(
                  location: LocationInfo(
                    location_id: e.location_id,
                    location_name: e.location_name,
                    location_type: e.location_type,
                    address: e.address,
                    longitude: e.longitude,
                    latitude: e.latitude,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
