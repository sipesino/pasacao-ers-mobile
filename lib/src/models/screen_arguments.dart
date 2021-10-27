import 'package:flutter/material.dart';
import 'package:pers/src/models/user.dart';

class ScreenArguments {
  final String? incidentType;
  final User? user;
  final IconData? icon;
  final String? verificationType;

  ScreenArguments({
    this.verificationType,
    this.icon,
    this.user,
    this.incidentType,
  });
}
