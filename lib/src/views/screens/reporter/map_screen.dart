import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/.env.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/directions.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool show_map = false;
  BitmapDescriptor? policeStationMarker;
  BitmapDescriptor? fireStationMarker;
  BitmapDescriptor? hospitalMarker;
  BitmapDescriptor? evacuationMarker;

  var args;

  Set<Marker> _markers = {};
  Directions? _info;

  late LocationData current_location;
  late Location location;

  void getDirections() async {
    Dio dio = new Dio();
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
    final response = await dio.get(
      baseUrl,
      queryParameters: {
        'origin': '${current_location.latitude},${current_location.longitude}',
        'destination':
            '${args!.destination!.latitude},${args!.destination!.longitude}',
        'key': googleAPIKey,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _info = Directions.fromMap(response.data);
      });
    }
  }

  void _setCustomMarker() {
    getBytesFromAsset('assets/images/markers/police_station.png', 80)
        .then((onValue) {
      policeStationMarker = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/images/markers/fire_station.png', 80)
        .then((onValue) {
      fireStationMarker = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/images/markers/hospital.png', 80).then((onValue) {
      hospitalMarker = BitmapDescriptor.fromBytes(onValue);
    });
    getBytesFromAsset('assets/images/markers/evacuation.png', 80)
        .then((onValue) {
      evacuationMarker = BitmapDescriptor.fromBytes(onValue);
    });
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  BitmapDescriptor setMarkerIcon(String location_type) {
    switch (location_type) {
      case 'Hospital':
        return hospitalMarker!;
      case 'Police Station':
        return policeStationMarker!;
      case 'Fire Station':
        return fireStationMarker!;
      case 'Evacuation':
        return evacuationMarker!;
      default:
        return evacuationMarker!;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });

    Set<Marker> _mrkrs = getLocations()
        .map(
          (e) => Marker(
            markerId: MarkerId(e.location_id),
            position: LatLng(
              e.coordinates.latitude,
              e.coordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: e.location_name,
              snippet: e.address,
            ),
            icon: setMarkerIcon(e.location_type),
          ),
        )
        .toSet();

    setState(() {
      _markers = _mrkrs;
    });

    if (args.destination != null) getDirections();

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
  }

  @override
  void initState() {
    super.initState();
    _setCustomMarker();
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
    if (args.destination != null) getDirections();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
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
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      current_location.latitude!,
                      current_location.longitude!,
                    ),
                    zoom: 18,
                  ),
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.blue,
                        endCap: Cap.roundCap,
                        startCap: Cap.roundCap,
                        width: 5,
                        points: _info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  buildingsEnabled: true,
                  tiltGesturesEnabled: false,
                ),
                if (_info != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.amber[800],
                        boxShadow: boxShadow,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_info!.totalDistance}, ${_info!.totalDuration}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
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
