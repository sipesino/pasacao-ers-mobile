import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/location_card.dart';

class LocationsScreen extends StatefulWidget {
  final ScrollController? controller;
  const LocationsScreen({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  var _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = true;
    widget.controller!.addListener(() {
      if (widget.controller!.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          if (mounted)
            setState(() {
              _isVisible = false;
            });
        }
      } else {
        if (widget.controller!.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            if (mounted)
              setState(() {
                _isVisible = true;
              });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            controller: widget.controller,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildColumn(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
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
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/reporter/home/map',
                    arguments: ScreenArguments(),
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
        SizedBox(
          height: 20,
        ),
        _buildLocationsStats(),
        Column(
          children: getLocations()
              .map(
                (e) => LocationCard(
                  location: Location(
                    location_id: e.location_id,
                    location_name: e.location_name,
                    location_type: e.location_type,
                    address: e.address,
                    coordinates: e.coordinates,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLocationsStats() {
    return Card(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: accentColor,
          boxShadow: boxShadow,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFC9842),
              Color(0xFFFE5F75),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Police Stations',
                    textAlign: TextAlign.center,
                    style: DefaultTextTheme.headline5,
                  ),
                  Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Fire Stations',
                    textAlign: TextAlign.center,
                    style: DefaultTextTheme.headline5,
                  ),
                  Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hospitals/Clinics',
                    textAlign: TextAlign.center,
                    style: DefaultTextTheme.headline5,
                  ),
                  Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
