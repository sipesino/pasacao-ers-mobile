import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pers/.env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/directions.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';

class NewOperation extends StatefulWidget {
  NewOperation({Key? key}) : super(key: key);

  @override
  _NewOperationState createState() => _NewOperationState();
}

class _NewOperationState extends State<NewOperation> {
  GoogleMapController? _controller;
  bool show_map = false;
  Set<Marker> _markers = {};
  Directions? _info;

  Set<Polyline> polylines = {};

  bool _isExpanded = false;
  bool _isInitialized = false;

  double _opacity = 1;

  var args;
  BitmapDescriptor? incidentLocationMarker;

  late LocationData current_location;
  late Location location;

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
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _opacity = _opacity == 1 ? 0 : 1;
            });
          },
          icon: Icon(_opacity == 1 ? Icons.visibility_off : Icons.visibility),
        ),
        SizedBox(width: 20)
      ],
    );

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
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
                buildOperationInfo(context, appBar),
              ],
            ),
    );
  }

  Widget buildOperationInfo(BuildContext context, AppBar appBar) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 150),
      opacity: _opacity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTopBanner(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        curve: Curves.easeInCirc,
                        height: _isExpanded
                            ? MediaQuery.of(context).size.height -
                                (appBar.preferredSize.height + 290)
                            : 130,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: boxShadow,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ListView(
                            padding: EdgeInsets.all(20),
                            children: [
                              Text(
                                'Operation Info',
                                style: DefaultTextTheme.headline4,
                              ),
                              SizedBox(height: 15),
                              buildOperationDetail(
                                field: 'Sex',
                                value: 'Female',
                              ),
                              buildOperationDetail(
                                field: 'Age',
                                value: '27',
                              ),
                              buildOperationDetail(
                                field: 'Status',
                                value: 'Conscious and Responsive',
                              ),
                              buildOperationDetail(
                                field: 'Description',
                                value:
                                    'Na heat stroke si ate gurl. namastal na kaya. The quick brownfox jumps over the lazy dog. Lorem ipsum sit dolor amet.',
                              ),
                              buildOperationDetail(
                                field: 'Landmark',
                                value: 'Front of Caranan National High School',
                              ),
                            ],
                          ),
                        ),
                      ),
                      buildExpandButton(context),
                    ],
                  ),
                  SizedBox(height: 10),
                  buildRespondButton(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOperationDetail({required String field, required String value}) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            SizedBox(
              width: 80,
              child: Text(
                field,
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value,
                  style: DefaultTextTheme.headline5,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildRespondButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(accentColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        onPressed: () {},
        child: Text('Respond'),
      ),
    );
  }

  Widget buildExpandButton(BuildContext context) {
    return Transform.translate(
      offset: Offset(MediaQuery.of(context).size.width - 100, -20),
      child: ClipOval(
        child: SizedBox(
          width: 40,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(
              _isExpanded
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: accentColor,
            ),
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                EdgeInsets.zero,
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTopBanner() {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        boxShadow: boxShadow,
      ),
      height: 120,
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Medical Incident',
                  style: DefaultTextTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Danao Pasacao Rd, Pasacao, Camarines Sur',
                  style: DefaultTextTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _info != null
                      ? '${_info!.totalDistance}, ${_info!.totalDuration}'
                      : '',
                  style: DefaultTextTheme.subtitle2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          ClipOval(
            child: SizedBox(
              width: 60,
              height: 60,
              child: ElevatedButton(
                onPressed: () => updatePinOnMap(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    accentColor,
                  ),
                ),
                child: Icon(
                  CustomIcons.siren_filled,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget setDetail({required String field_name, required String value}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            field_name,
            style: DefaultTextTheme.bodyText1,
          ),
        ),
        VerticalDivider(
          color: primaryColor,
        ),
        Expanded(
          child: Text(
            value,
            style: DefaultTextTheme.headline4,
          ),
        ),
      ],
    );
  }

  displayDistanceAndETA() {
    if (_info != null)
      return Positioned(
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
      );
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
      if (!_isInitialized) _setMapFitToTour({polyline});
      _isInitialized = true;
      polylines.add(polyline);
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
    if (args.destination != null) getDirections(current_location);
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
    Dio dio = new Dio();
    String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';
    final response = await dio.get(
      baseUrl,
      queryParameters: {
        'origin': '${curLoc.latitude},${curLoc.longitude}',
        'destination': '13.524416, 123.015583',
        'key': googleAPIKey,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _info = Directions.fromMap(response.data);
        setPolylines();
      });
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
    _controller!.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });

    Set<Marker> _mrkrs = {
      Marker(
        markerId: MarkerId('incident_location'),
        position: LatLng(13.524416, 123.015583),
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

    if (args.destination != null) {
      getDirections(current_location);
    }

    _controller = controller;
  }
}
