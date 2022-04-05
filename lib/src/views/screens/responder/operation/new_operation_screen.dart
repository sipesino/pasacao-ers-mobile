import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:pers/.env.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/directions.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/operation.dart';
import 'package:pers/src/models/permission_handler.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_gender_picker.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

extension StringExtension on String {
  String get totTitleCase => this
      .split(" ")
      .map((str) => '${str[0].toUpperCase()}${str.substring(1).toLowerCase()}')
      .join(" ");
  String totTitle() {
    final List<String> splitStr = this.split(' ');
    for (int i = 0; i < splitStr.length; i++) {
      splitStr[i] =
          '${splitStr[i][0].toUpperCase()}${splitStr[i].substring(1)}';
    }
    final output = splitStr.join(' ');
    return output;
  }
}

class NewOperation extends StatefulWidget {
  NewOperation({Key? key}) : super(key: key);

  @override
  _NewOperationState createState() => _NewOperationState();
}

class _NewOperationState extends State<NewOperation> {
  //google maps variables
  Completer<GoogleMapController> _controller = Completer();
  StreamSubscription<LocationData>? locationSubscription;
  final _formKey = GlobalKey<FormState>();
  bool show_map = false;
  Set<Marker> _markers = {};
  Directions? _info;
  LocationData? current_location;
  Location? location;
  int polyId = 1;
  double bearing = 0;

  //PolylinePoints variables
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  Set<Polyline> polylines = {};

  bool _isInitialized = false;

  //marker icons variables
  BitmapDescriptor? incidentLocationMarker;
  BitmapDescriptor? receivingFacilityMarker;

  int index = 0;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final addressValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 10 characters is required'),
  ]);

  final landmarkValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 8 characters is required'),
  ]);

  final ageValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    PatternValidator(
      r'(^(?=.*[1-9])\d*\.?\d*$)',
      errorText: 'Whole numbers only',
    ),
  ]);

  final sexValidator = MultiValidator([
    RequiredValidator(errorText: 'Sex is required'),
  ]);

  //operation info variables
  bool _isExpanded = false;
  bool _isResponding = false;
  bool _hidden = false;
  Operation? operation;
  String time = '00:00 AM';
  PageController pageController = new PageController();

  String? name;
  String? age;
  String? sex;
  String? address;
  String? temperature;
  String? pulse_rate;
  String? respiration_rate;
  String? blood_pressure;
  String? bp1;
  String? bp2;
  String? etd_base;
  String? eta_scene;
  String? etd_scene;
  String? eta_hospital;
  String? etd_hospital;
  String? eta_base;
  String? receivingFacility;
  String? nd_latitude;
  String? nd_longitude;

  final rfValidator = MultiValidator([
    RequiredValidator(errorText: 'Please indicate receiving facility'),
  ]);

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    locationSubscription?.cancel();
  }

  @override
  void initState() {
    super.initState();

    PermissionHandler.checkLocationPermission();
    location = new Location();
    setInitialLocation();
    polylinePoints = PolylinePoints();
    locationSubscription =
        location?.onLocationChanged.listen((LocationData cLoc) {
      current_location = cLoc;
      // updatePinOnMap();
      setPolylines();
      setState(() {
        bearing = current_location!.heading!;
      });
    });

    _setCustomMarker();

    time = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  Widget build(BuildContext context) {
    ScreenArguments args =
        ModalRoute.of(context)!.settings.arguments! as ScreenArguments;
    operation = args.operation;

    AppBar appBar = AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _hidden = _hidden == true ? false : true;
            });
            pageController = PageController(initialPage: index);
          },
          icon: Icon(_hidden == 1 ? Icons.visibility_off : Icons.visibility),
        ),
        SizedBox(width: 20)
      ],
    );

    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          !show_map
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      current_location!.latitude!,
                      current_location!.longitude!,
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
                ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            child: _hidden
                ? SizedBox.shrink()
                : SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 150),
                        child: !_isResponding
                            ? buildOperationInfo(context, appBar, args)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ExpandablePageView(
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: pageController,
                                    children: [
                                      BuildBaseDepartPhase(),
                                      BuildSceneArrivalPhase(),
                                      BuildSceneDepartPhase(),
                                      BuildPatientInfoForm(),
                                      BuildVitalSignForm(),
                                      BuildReceivingFacilityArrivalPhase(),
                                      BuildRFDeparturePhase(),
                                      BuildBaseArrivalPhase(),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      time = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm aa').format(dateTime);
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
                Text(
                  'Depart from base',
                  style: DefaultTextTheme.headline5,
                ),
                Text(
                  time,
                  style: DefaultTextTheme.headline1,
                ),
                buildNavigationButtons(
                  onPressed: () {
                    etd_base = DateTime.now().toString();
                    index = 1;
                    pageController.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildSceneArrivalPhase() {
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
                Text(
                  'Arrived at the scene',
                  style: DefaultTextTheme.headline5,
                ),
                Text(
                  time,
                  style: DefaultTextTheme.headline1,
                ),
                buildNavigationButtons(onPressed: () {
                  eta_scene = DateTime.now().toString();
                  index = 2;
                  pageController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildSceneDepartPhase() {
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Depart from scene',
                    style: DefaultTextTheme.headline5,
                  ),
                  Text(
                    time,
                    style: DefaultTextTheme.headline1,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Receiving Facility',
                      style: TextStyle(color: contentColorLightTheme),
                    ),
                  ),
                  SizedBox(height: 5),
                  DropdownSearch<LocationInfo>(
                    mode: Mode.BOTTOM_SHEET,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (u) =>
                        u == null ? "Please indicate receiving facility" : null,
                    dropdownSearchDecoration: InputDecoration(
                      hintText: 'Receiving Facility',
                      prefixIconColor: contentColorLightTheme,
                      prefixIcon: Icon(CustomIcons.cross, size: 15),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: contentColorLightTheme.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: contentColorLightTheme.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: chromeColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      focusColor: accentColor,
                    ),
                    items: [
                      LocationInfo(
                        location_name: 'Bicol Medical Center',
                        location_type: 'Hospital',
                        latitude: '13.622969196874783',
                        longitude: '123.1987274877563',
                      ),
                      LocationInfo(
                        location_name: 'Mother Seton',
                        location_type: 'Hospital',
                        latitude: '13.620336742324852',
                        longitude: '123.20075894366795',
                      ),
                      LocationInfo(
                        location_name: 'St. John Hospital',
                        location_type: 'Hospital',
                        latitude: '13.622964748278392',
                        longitude: '123.19047700181723',
                      ),
                      LocationInfo(
                        location_name: 'NICC Doctors Hospital',
                        location_type: 'Hospital',
                        latitude: '13.616231763348953',
                        longitude: '123.1926857722549',
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        receivingFacility = val.location_name;

                        String type;
                        switch (val.location_type?.toUpperCase()) {
                          case 'HOSPITAL':
                            type = 'hospital';
                            break;
                          case 'FIRE STATION':
                            type = 'fire_station';
                            break;
                          case 'POLICE STATION':
                            type = 'police_station';
                            break;
                          case 'EVACUATION CENTER':
                            type = 'evacuation';
                            break;
                          default:
                            type = 'hospital';
                        }
                        getBytesFromAsset('assets/images/markers/$type.png', 80)
                            .then((onValue) {
                          receivingFacilityMarker =
                              BitmapDescriptor.fromBytes(onValue);

                          setState(() {
                            operation!.report!.latitude = val.latitude;
                            operation!.report!.longitude = val.longitude;
                            _isInitialized = false;
                          });

                          _setNewDestination(
                            'receiving facility',
                            receivingFacility!,
                            receivingFacilityMarker!,
                            val.latitude!,
                            val.longitude!,
                          );
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  buildNavigationButtons(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final controller = await _controller.future;
                        controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(
                                current_location!.latitude!,
                                current_location!.longitude!,
                              ),
                              zoom: 50,
                              bearing: bearing,
                            ),
                          ),
                        );
                        etd_scene = DateTime.now().toString();

                        index = 3;
                        pageController.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  final pi_formKey = GlobalKey<FormState>();

  Widget BuildPatientInfoForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
      child: Form(
        key: pi_formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: boxShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Information',
                style: DefaultTextTheme.headline5,
              ),
              SizedBox(height: 10),
              NameTextField(operation?.report!.name),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SexPicker(operation!.report!.sex)),
                  SizedBox(
                    width: 110,
                    child: AgeTextField(operation?.report!.age),
                  ),
                ],
              ),
              SizedBox(height: 10),
              AddressTextField(),
              SizedBox(height: 10),
              buildNavigationButtons(onPressed: () {
                if (pi_formKey.currentState!.validate()) {
                  pi_formKey.currentState!.save();
                  index = 4;
                  pageController.nextPage(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget AddressTextField() {
    return CustomTextFormField(
      validator: addressValidator,
      keyboardType: TextInputType.streetAddress,
      label: 'Permanent Address',
      onSaved: (value) {
        if (value != null) address = value.trim();
      },
      prefixIcon: CustomIcons.map,
    );
  }

  final vs_formKey = GlobalKey<FormState>();

  Widget BuildVitalSignForm() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
      child: Form(
        key: vs_formKey,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: boxShadow,
          ),
          child: Column(
            children: [
              Text(
                'Patient Vital Sign',
                style: DefaultTextTheme.headline5,
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 170,
                child: buildCustomTextField(
                  label: 'Temperature (°C)',
                  onSaved: (val) {
                    temperature = val?.trim();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 170,
                child: buildCustomTextField(
                  label: 'Pulse Rate (BPM)',
                  onSaved: (val) {
                    pulse_rate = val?.trim();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 170,
                child: buildCustomTextField(
                  label: 'Respiration Rate (BPM)',
                  onSaved: (val) {
                    respiration_rate = val?.trim();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Text(
                    'Blood Pressure',
                    style: TextStyle(color: contentColorLightTheme),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        child: buildCustomTextField(
                          onSaved: (val) {
                            bp1 = val?.trim();
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Text('  /  '),
                      SizedBox(
                        width: 80,
                        child: buildCustomTextField(
                          onSaved: (val) {
                            bp2 = val?.trim();
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              buildNavigationButtons(onPressed: () {
                vs_formKey.currentState!.save();
                index = 5;
                pageController.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget BuildReceivingFacilityArrivalPhase() {
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
                Text(
                  'Arrived at the receiving facility',
                  style: DefaultTextTheme.headline5,
                ),
                Text(
                  time,
                  style: DefaultTextTheme.headline1,
                ),
                SizedBox(height: 10),
                buildNavigationButtons(
                  onPressed: () {
                    eta_hospital = DateTime.now().toString();
                    index = 6;
                    pageController.nextPage(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildRFDeparturePhase() {
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
                Text(
                  'Depart from receiving facility',
                  style: DefaultTextTheme.headline5,
                ),
                Text(
                  time,
                  style: DefaultTextTheme.headline1,
                ),
                buildNavigationButtons(
                  onPressed: () {
                    getBytesFromAsset('assets/images/markers/base.png', 80)
                        .then((onValue) {
                      setState(() {
                        nd_latitude = mdrrmo_latitude;
                        nd_longitude = mdrrmo_longitude;
                      });

                      _setNewDestination(
                        'base',
                        receivingFacility!,
                        BitmapDescriptor.fromBytes(onValue),
                        mdrrmo_latitude,
                        mdrrmo_longitude,
                      );
                      etd_hospital = DateTime.now().toString();
                      index = 7;
                      pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget BuildBaseArrivalPhase() {
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
                Text(
                  'Arrived at the base',
                  style: DefaultTextTheme.headline5,
                ),
                Text(
                  time,
                  style: DefaultTextTheme.headline1,
                ),
                buildNavigationButtons(
                  onPressed: () {
                    eta_base = DateTime.now().toString();
                    index = 8;
                    Navigator.of(context)
                        .pushNamed('/responder/home/new_operation/summary');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavigationButtons({required VoidCallback onPressed}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            if (index == 0) {
              _isResponding = false;
            } else {
              pageController.previousPage(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeIn,
              );
            }
            index--;
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Text('Back'),
        ),
        SizedBox(width: 10),
        Flexible(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(accentColor),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: Text('Confirm'),
          ),
        ),
      ],
    );
  }

  Widget buildCustomTextField({
    String? label,
    required FormFieldSetter<String> onSaved,
    required TextInputType keyboardType,
  }) {
    return Column(
      children: [
        if (label != null)
          Text(
            label,
            style: TextStyle(color: contentColorLightTheme),
          ),
        SizedBox(height: 5),
        TextFormField(
          onSaved: onSaved,
          keyboardType: keyboardType,
          textAlign: TextAlign.center,
          decoration: tff_decoration(),
        ),
      ],
    );
  }

  Widget NameTextField(String? name) {
    return CustomTextFormField(
      keyboardType: TextInputType.name,
      label: 'Victim Name',
      initialValue: name,
      onSaved: (value) {
        if (value != null) name = value.trim();
      },
      validator: nameValidator,
      prefixIcon: CustomIcons.person,
    );
  }

  Widget SexPicker(String? s) {
    return CustomGenderPicker(
      initialValue: s?.toUpperCase().trim() == 'MALE' ? 0 : 1,
      onChanged: (val) {
        sex = val;
      },
    );
  }

  Widget AgeTextField(String? a) {
    return CustomTextFormField(
      keyboardType: TextInputType.number,
      prefixIcon: CustomIcons.age,
      label: 'Age',
      initialValue: a,
      onSaved: (val) {
        age = val;
      },
      validator: ageValidator,
    );
  }

  InputDecoration tff_decoration() {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: contentColorLightTheme.withOpacity(0.2),
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: contentColorLightTheme.withOpacity(0.2),
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: chromeColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      focusColor: accentColor,
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Base Arrival"),
      content: Text("Confirm base arrival?"),
      actions: [
        noButton,
        yesButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildOperationInfo(
      BuildContext context, AppBar appBar, ScreenArguments args) {
    return SafeArea(
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: boxShadow,
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Operation Info',
                              style: DefaultTextTheme.headline4,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() => _isExpanded = !_isExpanded);
                            },
                            child: Text(_isExpanded ? 'Hide' : 'Show'),
                          )
                        ],
                      ),
                      if (_isExpanded)
                        Column(
                          children: [
                            buildOperationDetail(
                              field: 'Age',
                              value: args.operation?.report?.age ?? 'Undefined',
                            ),
                            buildOperationDetail(
                              field: 'Sex',
                              value:
                                  args.operation?.report?.sex?.totTitleCase ??
                                      'Undefined',
                            ),
                            buildOperationDetail(
                              field: 'Victim Status',
                              value: args.operation?.report?.victim_status
                                      ?.totTitleCase ??
                                  'Undefined',
                            ),
                            buildOperationDetail(
                              field: 'Description',
                              value: args.operation?.report?.description ??
                                  'Undefined',
                            ),
                            buildOperationDetail(
                              field: 'Landmark',
                              value: args.operation?.report?.landmark ??
                                  'Undefined',
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                buildRespondButton(),
              ],
            ),
          ],
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
                  boxShadow: boxShadow,
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
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;

          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  current_location!.latitude!,
                  current_location!.longitude!,
                ),
                zoom: 50,
                bearing: bearing,
              ),
            ),
            // CameraUpdate.newLatLngZoom(
            //   LatLng(
            //       current_location!.latitude!, current_location!.longitude!),
            //   50,
            // ),
          );

          setState(() {
            _isResponding = true;
          });
          // Navigator.of(context).pushReplacementNamed(
          //   '/responder/home/proceeding_operation',
          //   arguments: ScreenArguments(
          //     longitude: '123.040576',
          //     latitude: '13.504323',
          //   ),
          // );
        },
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
        color: Colors.white,
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
                  operation?.report?.incident_type?.totTitleCase ?? 'Undefined',
                  style: DefaultTextTheme.headline3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Danao Pasacao Rd, Pasacao, Camarines Sur',
                  style: DefaultTextTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_info != null)
                  Text(
                    '${_info!.totalDistance}, ${_info!.totalDuration}',
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
  setPolylines() async {
    final result = await polylinePoints?.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(
        current_location!.latitude!,
        current_location!.longitude!,
      ),
      PointLatLng(
        double.parse(operation!.report!.latitude!),
        double.parse(operation!.report!.longitude!),
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

      setState(() {
        polylines.add(
          Polyline(
            polylineId: polylineId,
            width: 5,
            color: Colors.blue,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            // set the width of the polylines
            points: polylineCoordinates,
          ),
        );
      });
      if (!_isInitialized) {
        print('>>> Initial camera position was set');
        _setMapFitToTour(polylines);
      }
      _isInitialized = true;
      // polylineCoordinates.clear();
    }
    // if (_info!.polylinePoints != null) {
    //   polylines.clear();
    //   Polyline polyline = Polyline(
    //     polylineId: const PolylineId('overview_polyline'),
    //     color: Colors.blue,
    //     endCap: Cap.roundCap,
    //     startCap: Cap.roundCap,
    //     width: 5,
    //     points: _info!.polylinePoints!
    //         .map((e) => LatLng(e.latitude, e.longitude))
    //         .toList(),
    //   );
    // if (!_isInitialized) {
    //   _setMapFitToTour(polylines);
    // }
    // _isInitialized = true;
    // polylines.add(polyline);
    // }
  }

  void updatePinOnMap() async {
    current_location = await location?.getLocation();
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location!.latitude!,
        current_location!.longitude!,
      ),
      bearing: bearing,
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
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

  void getDirections(
    LocationData curLoc,
    String latitude,
    String longitude,
  ) async {
    try {
      Dio dio = new Dio();
      String baseUrl = 'https://maps.googleapis.com/maps/api/directions/json?';

      final response = await dio.get(
        baseUrl,
        queryParameters: {
          'origin': '${curLoc.latitude},${curLoc.longitude}',
          'destination': '$latitude, $longitude',
          'key': googleAPIKey,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _info = Directions.fromMap(response.data);
          setPolylines();
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  void setInitialLocation() async {
    current_location = await location?.getLocation();
    setState(() {
      show_map = true;
    });
    CameraPosition cPosition = CameraPosition(
      target: LatLng(
        current_location!.latitude!,
        current_location!.longitude!,
      ),
      zoom: 18,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
  }

  void _onMapCreated(GoogleMapController controller) {
    rootBundle.loadString('assets/json/custom_map_style.json').then((string) {
      controller.setMapStyle(string);
    });

    _controller.complete(controller);
    setPolylines();

    _setNewDestination(
      'incident_location',
      operation?.report?.incident_type?.totTitleCase ?? 'Undefined',
      incidentLocationMarker!,
      operation!.report!.latitude!,
      operation!.report!.longitude!,
    );
  }

  void _setNewDestination(
    String id,
    String title,
    BitmapDescriptor icon,
    String latitude,
    String longitude,
  ) {
    Set<Marker> _mrkrs = {
      Marker(
        markerId: MarkerId(id),
        position: LatLng(double.parse(latitude), double.parse(longitude)),
        infoWindow: InfoWindow(
          title: title,
        ),
        icon: icon,
      )
    };

    setState(() {
      _markers = _mrkrs;
    });

    // if (args.operation.report.latitude != null) {
    //   getDirections(current_location, latitude, longitude);
    // }
  }
}
