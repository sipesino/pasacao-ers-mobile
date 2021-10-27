import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';

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
    return LayoutBuilder(
      builder: (context, constraint) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: _buildColumn(),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 10,
              child: FloatingActionButton(
                backgroundColor: accentColor,
                onPressed: () {
                  Navigator.of(context).pushNamed('/reporter/home/map');
                },
                child: Icon(CustomIcons.map),
              ),
            ),
          ],
        );
      },
    );
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(),
      ],
    );
  }
}
