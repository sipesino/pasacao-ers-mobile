import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HotlineCard extends StatefulWidget {
  final String hotline_number;
  final String agency_name;
  final String hotline_type;

  const HotlineCard({
    Key? key,
    required this.hotline_number,
    required this.agency_name,
    required this.hotline_type,
  }) : super(key: key);

  @override
  State<HotlineCard> createState() => _HotlineCardState();
}

class _HotlineCardState extends State<HotlineCard> {
  getIcon() {
    if (widget.hotline_type == 'Police')
      return Icons.local_police;
    else if (widget.hotline_type == "Medic")
      return FontAwesomeIcons.hospitalSymbol;
    else
      return CustomIcons.fire;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                getIcon(),
                size: 30,
                color: accentColor,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.hotline_number,
                    style: DefaultTextTheme.headline4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.agency_name,
                    style: DefaultTextTheme.subtitle1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ClipOval(
              child: SizedBox(
                height: 40,
                width: 40,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _makePhoneCall('tel:${widget.hotline_number}');
                  }),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 20,
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
