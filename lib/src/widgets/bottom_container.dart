import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';

class BottomContainer extends StatelessWidget {
  const BottomContainer({
    required this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 60.0;
    const buttonWidth = 90.0;
    return Stack(
      children: [
        Container(
          height: buttonHeight * 1.5,
          color: chromeColor,
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
