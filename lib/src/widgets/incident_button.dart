import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';

class IncidentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Gradient gradient;
  final VoidCallback onPressed;

  const IncidentButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        height: 100.0,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: Colors.white,
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: new Offset(-10, 10),
              blurRadius: 20.0,
              spreadRadius: 4.0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(
                  CustomIcons.right_arrow,
                  size: 15,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
