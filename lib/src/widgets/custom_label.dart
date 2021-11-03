import 'package:flutter/material.dart';
import 'package:pers/src/theme.dart';

class CustomLabel extends StatelessWidget {
  final String label;
  final String value;

  const CustomLabel({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 5),
          Text(
            value,
            style: DefaultTextTheme.headline4,
          ),
        ],
      ),
    );
  }
}
