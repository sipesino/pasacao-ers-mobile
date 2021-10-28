import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            new BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: new Offset(-10, 10),
              blurRadius: 10.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.hotline_number,
                  style: DefaultTextTheme.headline3,
                ),
                Text(
                  widget.agency_name,
                  style: DefaultTextTheme.subtitle1,
                ),
              ],
            ),
            IconButton(
                onPressed: () => setState(() {
                      _makePhoneCall('tel:${widget.hotline_number}');
                    }),
                icon: Icon(
                  Icons.phone,
                  color: Colors.green,
                  size: 30,
                )),
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
