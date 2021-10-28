import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/location_widget.dart';

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 40),
                      child: _buildColumn(),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                right: 15,
                child: FloatingActionButton(
                  backgroundColor: accentColor,
                  onPressed: () {
                    Navigator.pushNamed(context, '/reporter/home/map');
                  },
                  child: Icon(CustomIcons.map),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildColumn() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Locations',
            style: DefaultTextTheme.headline4,
          ),
          LocationCard(),
        ],
      ),
    );
  }
}
