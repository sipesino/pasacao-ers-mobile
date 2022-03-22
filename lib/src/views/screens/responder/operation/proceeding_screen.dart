import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/directions.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pers/.env.dart';

class ProceedingScreen extends StatefulWidget {
  ProceedingScreen({Key? key}) : super(key: key);

  @override
  State<ProceedingScreen> createState() => _ProceedingScreenState();
}

class _ProceedingScreenState extends State<ProceedingScreen> {
  GoogleMapController? _controller;
  bool show_map = false;
  bool _isInitialized = false;
  Set<Marker> _markers = {};
  Directions? _info;
  Set<Polyline> polylines = {};
  late LocationData current_location;
  late Location location;
  var args;
  BitmapDescriptor? incidentLocationMarker;
  PageController pageController = new PageController();

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();

    PermissionHandler.checkLocationPermission();
    print('Checked location permission');
    location = new Location();
    location.getLocation().then((cLoc) {
      current_location = cLoc;
      print(current_location.latitude);
      setInitialLocation();

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          show_map = true;
        });
      });
    });
    _setCustomMarker();
  }

  //set the lines of the direction to destination
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
      if (!_isInitialized) {
        _setMapFitToTour({polyline});
      }
      _isInitialized = true;
      polylines.add(polyline);
    } else {
      print('may mali');
    }
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

  //set camera to center of 2 markers
  void _setMapFitToTour(Set<Polyline> p) async {
    print(_isInitialized);
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
    else {
      print('_controller is null');
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

  void _setCustomMarker() {
    getBytesFromAsset('assets/images/markers/incident_location.png', 80)
        .then((onValue) {
      incidentLocationMarker = BitmapDescriptor.fromBytes(onValue);
    });
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
    print('Set initial location done');
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });

    Set<Marker> _mrkrs = {
      Marker(
        markerId: MarkerId('incident_location'),
        position:
            LatLng(double.parse(args.latitude), double.parse(args.longitude)),
        infoWindow: InfoWindow(
          title: 'Vehicle Accident',
          snippet: 'Danao Pasacao Rd, Pasacao, Camarines Sur',
        ),
        icon: incidentLocationMarker!,
      )
    };

    setState(() {
      _markers = _mrkrs;
    });

    _controller = controller;

    if (args.latitude != null) {
      getDirections(current_location);
    }
    print('On map created done');
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            !show_map
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder<LocationData>(
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
                          zoom: 5,
                        ),
                        polylines: polylines,
                        myLocationEnabled: true,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        buildingsEnabled: true,
                        tiltGesturesEnabled: false,
                        trafficEnabled: true,
                      );
                    },
                  ),
            PageView(
              controller: pageController,
              children: [
                BuildBaseDepartPhase(),
                BuildBaseDepartPhase(),
                BuildBaseDepartPhase(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget BuildBaseDepartPhase() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: boxShadow,
            ),
            child: Column(
              children: [
                Text('Proceeding Screen'),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(accentColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text('Click Me'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
