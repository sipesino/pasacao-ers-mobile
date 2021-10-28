import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/widgets/hotline_card.dart';

class HotlinesScreen extends StatefulWidget {
  HotlinesScreen({Key? key}) : super(key: key);

  @override
  _HotlinesScreenState createState() => _HotlinesScreenState();
}

class _HotlinesScreenState extends State<HotlinesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Hotlines',
          style: TextStyle(color: primaryColor),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
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
          ),
        );
      }),
    );
  }
}
