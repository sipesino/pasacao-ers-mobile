import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/.env.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/directions.dart';
import 'package:pers/src/models/locations.dart';
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
  var args;
  late LocationData current_location;
  PinInformation currentlySelectedPin = PinInformation(
    locationIcon: CustomIcons.siren_2,
    address: "",
    location: LatLng(0, 0),
    locationName: "",
  );

  BitmapDescriptor? evacuationMarker;
  BitmapDescriptor? fireStationMarker;
  BitmapDescriptor? hospitalMarker;
  late Location location;
  double pinPillPosition = -120;
  //Icons for location marker
  BitmapDescriptor? policeStationMarker;

  Set<Polyline> polylines = {};
  bool show_map = false;

  GoogleMapController? _controller;
  Directions? _info;
  bool _isInitialized = false;
  Set<Marker> _markers = {};

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
    _setCustomMarker();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void getDirections(LocationData curLoc) async {
    if (args.latitude != null)
      try {
        Dio dio = new Dio();
        String baseUrl =
            'https://maps.googleapis.com/maps/api/directions/json?';
        final response = await dio.get(
          baseUrl,
          queryParameters: {
            'origin': '${curLoc.latitude},${curLoc.longitude}',
            'destination': '${args.latitude}, ${args.longitude}',
            'key': googleAPIKey,
          },
        );

        if (response.statusCode == 200) {
          setState(() {
            _info = Directions.fromMap(response.data);

            setPolylines();
          });
        }
      } catch (e) {
        print(e);
      }
  }

  void getDistanceAndReach(LatLng destination) async {
    try {
      Dio dio = new Dio();
      String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'origin':
              '${current_location.latitude},${current_location.longitude}',
          'destination': '${destination.latitude}, ${destination.longitude}',
          'key': googleAPIKey,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _info = Directions.fromMap(response.data);
          setPolylines();
        });
      } else {
        print('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
        print(response.data);
        print('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n');
      }
    } catch (e) {
      print(e);
    }
  }

  setPolylines() {
    if (_info!.polylinePoints != null) {
      polylines.clear();
      Polyline polyline = Polyline(
        polylineId: const PolylineId('overview_polyline'),
        color: Colors.blue,
        endCap: Cap.roundCap,
        startCap: Cap.roundCap,
        width: 5,
        points: _info!.polylinePoints!
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
      );
      if (!_isInitialized) _setMapFitToTour({polyline});
      _isInitialized = true;
      polylines.add(polyline);
    }
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

  void setmarkerTapAction(LocationInfo e) async {
    setState(() {
      args = ScreenArguments();
      currentlySelectedPin = PinInformation(
        locationIcon: getLocationIcon(e.location_type),
        location: LatLng(
          double.parse(e.latitude),
          double.parse(e.longitude),
        ),
        locationName: e.location_name,
        address: e.address,
      );

      pinPillPosition = 0;
    });
    if (await DataConnectionChecker().hasConnection)
      getDistanceAndReach(
        LatLng(
          double.parse(e.latitude),
          double.parse(e.longitude),
        ),
      );
  }

  void setInitialLocation() async {
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location.latitude!,
        current_location.longitude!,
      ),
      zoom: 18,
    );
    if (_controller != null)
      _controller!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void updatePinOnMap() async {
    current_location = await location.getLocation();
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location.latitude!,
        current_location.longitude!,
      ),
      zoom: 18,
    );
    _controller!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    if (args.latitude != null) getDirections(current_location);
  }

  getLocationIcon(String location_type) {
    switch (location_type) {
      case 'Hospital':
        return CustomIcons.cross;
      case 'Police Station':
        return CustomIcons.badge;
      case 'Fire Station':
        return CustomIcons.firefighter;
      case 'Evacuation':
        return CustomIcons.evacuation_point;
      default:
        return CustomIcons.evacuation_point;
    }
  }

  //set camera to center of 2 markers
  void _setMapFitToTour(Set<Polyline> p) async {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if (point.latitude < minLat) minLat = point.latitude;
        if (point.latitude > maxLat) maxLat = point.latitude;
        if (point.longitude < minLong) minLong = point.longitude;
        if (point.longitude > maxLong) maxLong = point.longitude;
      });
    });
    if (_controller != null)
      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLong),
            northeast: LatLng(maxLat, maxLong),
          ),
          50,
        ),
      );
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

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });

    Set<Marker> _mrkrs = getLocations()
        .map(
          (e) => Marker(
            markerId: MarkerId(e.location_id.toString()),
            position: LatLng(
              double.parse(e.latitude),
              double.parse(e.longitude),
            ),
            icon: setMarkerIcon(e.location_type),
            onTap: () {
              setmarkerTapAction(e);
            },
          ),
        )
        .toSet();

    setState(() {
      _markers = _mrkrs;
    });

    if (args.latitude != null && _info != null) getDirections(current_location);

    _controller = controller;
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
                StreamBuilder<LocationData>(
                    stream: location.onLocationChanged,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        LocationData curLoc = snapshot.data!;
                        getDirections(curLoc);
                      }
                      return GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            current_location.latitude!,
                            current_location.longitude!,
                          ),
                          zoom: 18,
                        ),
                        compassEnabled: false,
                        polylines: polylines,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        buildingsEnabled: true,
                        tiltGesturesEnabled: false,
                        onTap: (LatLng location) {
                          setState(() {
                            pinPillPosition = -120;
                          });
                        },
                      );
                    }),
                AnimatedPositioned(
                  bottom: pinPillPosition,
                  right: 0,
                  left: 0,
                  duration: Duration(milliseconds: 200),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: boxShadow,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: accentColor.withOpacity(0.1),
                            ),
                            child: Icon(
                              currentlySelectedPin.locationIcon,
                              size: 40,
                              color: accentColor,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${currentlySelectedPin.locationName}',
                                    style: DefaultTextTheme.headline5,
                                  ),
                                  Text('${currentlySelectedPin.address}',
                                      style: DefaultTextTheme.subtitle1),
                                  if (_info != null)
                                    Text(
                                      '${_info!.totalDistance}, ${_info!.totalDuration}',
                                      style: DefaultTextTheme.subtitle2,
                                    ),
                                ],
                              ),
                            ),
                          ), // second widget
                        ],
                      ),
                    ),
                  ),
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

class PinInformation {
  PinInformation({
    required this.locationIcon,
    required this.location,
    required this.locationName,
    required this.address,
  });

  String address;
  LatLng location;
  IconData locationIcon;
  String locationName;
}
