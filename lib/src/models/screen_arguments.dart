import 'package:flutter/material.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/user.dart';

class ScreenArguments {
  final String? incidentType;
  final User? user;
  final IconData? icon;
  final String? verificationType;
  final IncidentReport? incident_report;
  final String? longitude;
  final String? latitude;

  ScreenArguments({
    this.incident_report,
    this.verificationType,
    this.icon,
    this.user,
    this.incidentType,
    this.longitude,
    this.latitude,
  });
}
