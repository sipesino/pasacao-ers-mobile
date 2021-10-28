import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/location_widget.dart';

class LocationsScreen extends StatefulWidget {
  final ScrollController? controller;
  const LocationsScreen({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _hideFabAnimation;

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.forward();
            }
            break;
          case ScrollDirection.reverse:
            if (userScroll.metrics.maxScrollExtent !=
                userScroll.metrics.minScrollExtent) {
              _hideFabAnimation.reverse();
            }
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _hideFabAnimation = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _hideFabAnimation.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return Stack(
              children: [
                SingleChildScrollView(
                  controller: widget.controller,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: _buildColumn(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: ScaleTransition(
                    scale: _hideFabAnimation,
                    child: FloatingActionButton(
                      backgroundColor: accentColor,
                      onPressed: () {
                        Navigator.pushNamed(context, '/reporter/home/map');
                      },
                      child: Icon(CustomIcons.map),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Locations',
          style: DefaultTextTheme.headline4,
        ),
        SizedBox(
          height: 20,
        ),
        _buildLocationsStats(),
        LocationCard(),
        LocationCard(),
        LocationCard(),
        LocationCard(),
        LocationCard(),
        LocationCard(),
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
