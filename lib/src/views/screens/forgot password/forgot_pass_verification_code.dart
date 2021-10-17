import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/bottom_container.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordVerification extends StatefulWidget {
  ForgotPasswordVerification({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVerificationState createState() =>
      _ForgotPasswordVerificationState();
}

class _ForgotPasswordVerificationState
    extends State<ForgotPasswordVerification> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Text(
              'Back',
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Container(child: _buildColumn()),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTopContainer(),
        BottomContainer(
          onPressed: () async {
            if (currentText.length != 4) {
              errorController!.add(
                ErrorAnimationType.shake,
              ); // Triggering error shake animation
              setState(() => hasError = true);
            } else {
              Navigator.pushNamed(
                context,
                '/forgot_password/mobile_no/verification/new_password',
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildTopContainer() {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Icon(
                CustomIcons.opened_mail,
                size: 40,
                color: accentColor,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Check your inbox',
            style: DefaultTextTheme.headline2,
          ),
          SizedBox(
            width: 290,
            child: Text(
              'We have sent the code verification to your ${args.verificationType}.',
              textAlign: TextAlign.center,
              style: DefaultTextTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 250,
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              obscureText: false,
              animationType: AnimationType.fade,
              cursorColor: Colors.black,
              errorAnimationController: errorController,
              controller: textEditingController,
              enableActiveFill: true,
              pinTheme: PinTheme(
                inactiveFillColor: Colors.grey[200],
                selectedFillColor: Colors.grey[200],
                activeColor: Colors.white,
                selectedColor: chromeColor,
                errorBorderColor: Colors.redAccent,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.grey[200],
                borderWidth: 1.5,
                inactiveColor: Colors.white,
              ),
              onCompleted: (value) {},
              onChanged: (value) {
                setState(() {
                  currentText = value;
                });
              },
            ),
          ),
          Center(
            child: TextButton(
              child: Text('Try a different method'),
              onPressed: () {
                Navigator.popAndPushNamed(
                  context,
                  '/forgot_password/email',
                );
              },
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}
