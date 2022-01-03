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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            backgroundColor: Colors.transparent,
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: [
                                  Card(
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Emergency Hotlines',
                                          style: DefaultTextTheme.headline5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView(
                                      clipBehavior: Clip.antiAlias,
                                      shrinkWrap: true,
                                      children: [
                                        HotlineCard(
                                          agency_name: 'Pasacao PNP',
                                          hotline_number: '09123456789',
                                          hotline_type: 'Police',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao BFP',
                                          hotline_number: '+(63) 987-654-3210',
                                          hotline_type: 'Medic',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao MDRRMO',
                                          hotline_number: '09669777143',
                                          hotline_type: 'Mobile Number',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao PNP',
                                          hotline_number: '09123456789',
                                          hotline_type: 'Police',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao BFP',
                                          hotline_number: '+(63) 987-654-3210',
                                          hotline_type: 'Police',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao MDRRMO',
                                          hotline_number: '09669777143',
                                          hotline_type: 'Medic',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao PNP',
                                          hotline_number: '09123456789',
                                          hotline_type: 'Mobile Number',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao BFP',
                                          hotline_number: '+(63) 987-654-3210',
                                          hotline_type: 'Mobile Number',
                                        ),
                                        HotlineCard(
                                          agency_name: 'Pasacao MDRRMO',
                                          hotline_number: '09669777143',
                                          hotline_type: 'Mobile Number',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : SizedBox(),
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
