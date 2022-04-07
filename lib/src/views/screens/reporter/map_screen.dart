import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
  ScreenArguments? args;
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationData>? locationSubscription;
  late LocationData current_location;
  PinInformation currentlySelectedPin = PinInformation(
    locationIcon: CustomIcons.siren_2,
    address: "",
    location: LatLng(0, 0),
    locationName: "",
  );
  double bearing = 0;
  BitmapDescriptor? evacuationMarker;
  BitmapDescriptor? fireStationMarker;
  BitmapDescriptor? hospitalMarker;
  late Location location;
  double pinPillPosition = -120;
  String distance = '';

  String? dest_lat;
  String? dest_lng;

  //Icons for location marker
  BitmapDescriptor? policeStationMarker;

  //PolylinePoints variables
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  Set<Polyline> polylines = {};
  int polyId = 1;

  bool show_map = false;
  bool _isInitialized = false;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    PermissionHandler.checkLocationPermission();
    location = new Location();
    setInitialLocation();
    polylinePoints = PolylinePoints();
    locationSubscription =
        location.onLocationChanged.listen((LocationData cLoc) {
      current_location = cLoc;
      // updatePinOnMap();
      if (args?.latitude != null && !_isInitialized) {
        dest_lat = args!.latitude;
        dest_lng = args!.longitude;
        setPolylines();
      }

      setState(() {
        bearing = current_location.heading!;
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

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  setPolylines() async {
    final Connectivity _connectivity = Connectivity();

    _connectivity.checkConnectivity().then((status) async {
      ConnectivityResult _connectionStatus = status;
      if (_connectionStatus != ConnectivityResult.none) {
        final result = await polylinePoints?.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(
            current_location.latitude!,
            current_location.longitude!,
          ),
          PointLatLng(
            double.parse(dest_lat!),
            double.parse(dest_lng!),
          ),
        );

        if (result != null && result.points.isNotEmpty) {
          List<PointLatLng> points = result.points;
          polylineCoordinates.clear();
          points.forEach((PointLatLng point) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
          final String polylineIdVal = 'polyline_id_$polyId';
          polyId++;
          final PolylineId polylineId = PolylineId(polylineIdVal);
          polylines.clear();

          double totalDistance = 0.0;

          //get total distance from origin to destination
          for (int i = 0; i < polylineCoordinates.length - 1; i++) {
            totalDistance += _coordinateDistance(
              polylineCoordinates[i].latitude,
              polylineCoordinates[i].longitude,
              polylineCoordinates[i + 1].latitude,
              polylineCoordinates[i + 1].longitude,
            );
          }
          setState(() {
            distance = totalDistance.toStringAsFixed(2);
            polylines.add(
              Polyline(
                polylineId: polylineId,
                jointType: JointType.round,
                width: 5,
                color: Colors.blue,
                endCap: Cap.roundCap,
                startCap: Cap.roundCap,
                // set the width of the polylines
                points: polylineCoordinates,
              ),
            );
          });

          if (!_isInitialized && args?.latitude != null) {
            print('>>> Initial camera position was set');
            _setMapFitToTour(polylines);
          }
          _isInitialized = true;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: new Text('No internet connection'),
            backgroundColor: Colors.red,
            duration: new Duration(seconds: 3),
          ),
        );
      }
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

  void setmarkerTapAction(LocationInfo e) async {
    setState(() {
      currentlySelectedPin = PinInformation(
        locationIcon: getLocationIcon(e.location_type!),
        location: LatLng(
          double.parse(e.latitude!),
          double.parse(e.longitude!),
        ),
        locationName: e.location_name!,
        address: e.address!,
      );

      pinPillPosition = 0;
    });

    dest_lat = e.latitude;
    dest_lng = e.longitude;

    setPolylines();
  }

  void setInitialLocation() async {
    current_location = await location.getLocation();
    setState(() {
      show_map = true;
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

  void updatePinOnMap() async {
    current_location = await location.getLocation();
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
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
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

    _controller.complete(controller);

    Set<Marker> _mrkrs = getLocations()
        .map(
          (e) => Marker(
            markerId: MarkerId(e.location_id.toString()),
            position: LatLng(
              double.parse(e.latitude!),
              double.parse(e.longitude!),
            ),
            icon: setMarkerIcon(e.location_type!),
            onTap: () => setmarkerTapAction(e),
          ),
        )
        .toSet();

    setState(() {
      _markers = _mrkrs;
    });
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
                ),
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
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${currentlySelectedPin.address}',
                                    style: DefaultTextTheme.subtitle1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${distance} km away',
                                    style: DefaultTextTheme.subtitle2,
                                    overflow: TextOverflow.ellipsis,
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
