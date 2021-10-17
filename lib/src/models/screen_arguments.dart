import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:pers/src/models/user.dart';

class ScreenArguments {
  final String? incidentType;
  final User? user;
  final IconData? icon;
  final String? verificationType;
  final Location? location;

  ScreenArguments({
    this.verificationType,
    this.icon,
    this.user,
    this.incidentType,
    this.location,
  });
}
