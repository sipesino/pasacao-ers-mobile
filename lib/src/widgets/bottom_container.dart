import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';

class BottomContainer extends StatelessWidget {
  BottomContainer({
    required this.onPressed,
    this.displayHotlinesButton = false,
  });

  final VoidCallback? onPressed;
  bool displayHotlinesButton;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 60.0;
    const buttonWidth = 90.0;
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: buttonHeight * 1.5,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFECECF4),
          child: displayHotlinesButton
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: TextButton.icon(
                    label: Text(
                      'Emergency Hotlines',
                      style: TextStyle(
                        color: accentColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    icon: Icon(
                      Icons.phone,
                      color: accentColor,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('/reporter/home/hotlines');
                    },
                  ),
                )
              : SizedBox.shrink(),
        ),
        Transform.translate(
          offset: Offset(MediaQuery.of(context).size.width - (buttonWidth + 20),
              -buttonHeight / 2),
          child: SizedBox(
            height: buttonHeight,
            width: buttonWidth,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: onPressed,
              child: const Icon(
                CustomIcons.long_right_arrow,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
