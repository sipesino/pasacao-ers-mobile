import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
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
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      height: 75.0,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
        boxShadow: boxShadow,
      ),
      child: Material(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: '$label-icon',
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 170,
                child: Hero(
                  tag: label,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
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
    );
  }
}
