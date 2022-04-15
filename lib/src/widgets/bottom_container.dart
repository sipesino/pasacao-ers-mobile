import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/hotline_card.dart';

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
          height: buttonHeight * 1.5,
          width: MediaQuery.of(context).size.width,
          color: chromeColor,
          child: displayHotlinesButton
              ? Center(
                  child: TextButton.icon(
                    label: Text(
                      'Emergency Hotlines',
                      style: TextStyle(
                        color: accentColor,
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
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return Dialog(
                      //       insetPadding: EdgeInsets.symmetric(
                      //         vertical: 0,
                      //         horizontal: 20,
                      //       ),
                      //       backgroundColor: Colors.transparent,
                      //       child: Container(
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           mainAxisSize: MainAxisSize.min,
                      //           children: [
                      //             Card(
                      //               child: Container(
                      //                 width: double.infinity,
                      //                 padding: EdgeInsets.all(10),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius:
                      //                       BorderRadius.circular(10.0),
                      //                 ),
                      //                 child: Center(
                      //                   child: Text(
                      //                     'Emergency Hotlines',
                      //                     style: DefaultTextTheme.headline5,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //             Flexible(
                      //               child: SingleChildScrollView(
                      //                 child: Column(
                      //                   children: [
                      //                     HotlineCard(
                      //                       agency_name: 'Pasacao PNP',
                      //                       hotline_number: '09123456789',
                      //                       hotline_type: 'Police',
                      //                     ),
                      //                     HotlineCard(
                      //                       agency_name: 'Pasacao BFP',
                      //                       hotline_number:
                      //                           '+(63) 987-654-3210',
                      //                       hotline_type: 'Medic',
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // );
                    },
                  ),
                )
              : Text(''),
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
