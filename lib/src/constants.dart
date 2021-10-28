import 'package:flutter/material.dart';

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
    color: Colors.grey.withOpacity(0.3),
    offset: new Offset(0, 10),
    blurRadius: 15.0,
    spreadRadius: 0.0,
  ),
];

final String crimePng = 'assets/images/crime.png';
final String medicalPng = 'assets/images/medical.png';
final String firePng = 'assets/images/fire.png';
