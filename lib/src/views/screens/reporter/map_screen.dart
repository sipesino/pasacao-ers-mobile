import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/permission_handler.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool show_map = false;
  Set<Marker> _markers = {};
  late LocationData current_location;
  late CameraPosition initial_camera_position;
  late Location location;

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });
    _controller.complete(controller);
  }

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location.latitude!,
        current_location.longitude!,
      ),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    PermissionHandler.checkLocationPermission();
    location = new Location();
    location.getLocation().then((cLoc) {
      current_location = cLoc;
      setInitialLocation();
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          show_map = true;
        });
      });
    });
  }

  void updatePinOnMap() async {
    location.onLocationChanged.listen((cloc) {
      setState(() {
        current_location = cloc;
      });
    });
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location.latitude!,
        current_location.longitude!,
      ),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: !show_map
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              onMapCreated: _onMapCreated,
              markers: _markers,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  current_location.latitude!,
                  current_location.longitude!,
                ),
                zoom: 18,
              ),
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: false,
              buildingsEnabled: false,
              tiltGesturesEnabled: false,
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        onPressed: () {
          updatePinOnMap();
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
