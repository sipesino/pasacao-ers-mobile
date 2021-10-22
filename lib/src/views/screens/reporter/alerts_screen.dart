import 'package:flutter/material.dart';
import 'package:pers/src/theme.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          'Under Construction',
          style: DefaultTextTheme.headline4,
        ),
      ),
    );
    // return LayoutBuilder(builder: (context, constraint) {
    //   return SingleChildScrollView(
    //     child: ConstrainedBox(
    //       constraints: BoxConstraints(minHeight: constraint.maxHeight),
    //       child: Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //         child: Column(
    //           children: <Widget>[
    //             Text(''),
    //             Text(''),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // });
  }
}
