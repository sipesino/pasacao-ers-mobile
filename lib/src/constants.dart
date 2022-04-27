import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_types.dart';

const primaryColor = Color(0xFF1F2937);
const accentColor = Color(0xFFE05A45);
const chromeColor = Color(0xFFCCCCCC);
const contentColorLightTheme = Color(0xFF444A62);
const contentColorDarkTheme = Color(0xFFF5FCF9);
const defaultPadding = 20.0;
const fireDefaultColor = accentColor;
const crimeDefaultColor = Color(0xFF4F70A1);
const medicalDefaultColor = Color(0xFF81C6D6);

final List<BoxShadow> boxShadow = <BoxShadow>[
  BoxShadow(
    color: Colors.white.withOpacity(0.8),
    offset: Offset(-6.0, -6.0),
    blurRadius: 16.0,
  ),
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    offset: Offset(6.0, 6.0),
    blurRadius: 16.0,
  ),
];

final List<IncidentType> incident_types = [
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFF51ABF7),
        Color(0xFF5168FF),
      ],
    ),
    icon: CustomIcons.cross,
    label: 'Medical Emergency',
  ),
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xff6685FC),
        Color(0xFF9665FA),
      ],
    ),
    icon: FontAwesomeIcons.carCrash,
    label: 'Vehicle Accident',
  ),
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFEF60A3),
        Color(0xFF9665FA),
      ],
    ),
    icon: CustomIcons.criminal,
    label: 'Theft or Robbery',
  ),
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFdb7f8e),
        Color(0xFFaa4465),
      ],
    ),
    icon: FontAwesomeIcons.fistRaised,
    label: 'Assault',
  ),
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFFFC9842),
        Color(0xFFFE5F75),
      ],
    ),
    icon: CustomIcons.fire,
    label: 'Fire Incident',
  ),
  IncidentType(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        Color(0xFF35E688),
        Color(0xFF64A3E0),
      ],
    ),
    icon: CustomIcons.drowning,
    label: 'Drowning',
  ),
];

const String mdrrmo_latitude = "13.512623274675988";
const String mdrrmo_longitude = "123.04247497268386";
const String crimePng = 'assets/images/crime.png';
const String medicalPng = 'assets/images/medical.png';
const String firePng = 'assets/images/fire.png';
