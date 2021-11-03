import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/description_screen.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/location_screen.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({Key? key}) : super(key: key);

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != 2
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    Map<int, Color> color = {
      50: Color.fromRGBO(136, 14, 79, .1),
      100: Color.fromRGBO(136, 14, 79, .2),
      200: Color.fromRGBO(136, 14, 79, .3),
      300: Color.fromRGBO(136, 14, 79, .4),
      400: Color.fromRGBO(136, 14, 79, .5),
      500: Color.fromRGBO(136, 14, 79, .6),
      600: Color.fromRGBO(136, 14, 79, .7),
      700: Color.fromRGBO(136, 14, 79, .8),
      800: Color.fromRGBO(136, 14, 79, .9),
      900: Color.fromRGBO(136, 14, 79, 1),
    };

    List<Step> steps = [
      Step(
        title: Text(
          'Description',
          style: DefaultTextTheme.headline4,
        ),
        subtitle: Text(
          'Provide the specific details of the incident',
          style: DefaultTextTheme.subtitle1,
        ),
        content: DescriptionScreen(
          args: args,
        ),
        isActive: currentStep == 0,
        state: currentStep > 0 ? StepState.complete : StepState.editing,
      ),
      Step(
        title: Text(
          'Location',
          style: DefaultTextTheme.headline4,
        ),
        subtitle: Text(
          'Indicate the location of the incident',
          style: DefaultTextTheme.subtitle1,
        ),
        content: LocationScreen(),
        isActive: currentStep == 1,
        state: currentStep >= 1 ? StepState.editing : StepState.disabled,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Incident Report',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: primaryColor,
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(primary: accentColor),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: primaryColor),
        ),
        child: Stepper(
          steps: steps,
          currentStep: currentStep,
          onStepContinue: next,
          onStepCancel: cancel,
          onStepTapped: (step) => goTo(step),
        ),
      ),
    );
  }
}
