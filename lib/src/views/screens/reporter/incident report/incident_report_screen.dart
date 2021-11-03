import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/views/screens/reporter/incident%20report/location_screen.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({Key? key}) : super(key: key);

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  int currentStep = 0;

  final List<GlobalKey<FormState>> form_keys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  bool not_victim = false;
  bool _switchValue = true;

  String? incident_type;
  String? patient_name;
  String? sex;
  String? age;
  String? description;
  List<XFile> incident_images = [];

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final ageValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    PatternValidator(
      r'(^(?=.*[1-9])\d*\.?\d*$)',
      errorText: 'Whole numbers only',
    ),
  ]);

  final sexValidator = MultiValidator([
    RequiredValidator(errorText: 'Sex is required'),
  ]);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    pushSummaryScreen() {
      if (form_keys[0].currentState!.validate()) {
        form_keys[0].currentState!.save();

        //if reporter is the victim then retrieve patient name, sex and age information to his profile.
        if (!not_victim) {
          patient_name = '${args.user!.first_name!} ${args.user!.last_name!}';
          sex = args.user!.sex!;
          age = '10';
          //TODO: uncomment calcualte age method below
          // age = calculateAge(new DateFormat("yyyy-MM-dd").parse(args.user!.birthdate!)).toString();
        }

        var report = IncidentReport(
          incident_type: incident_type,
          patient_name: patient_name,
          sex: sex,
          age: age,
          description: description,
          incident_images: incident_images,
          location: 'Location',
        );

        Navigator.pushNamed(
          context,
          '/reporter/home/report/summary',
          arguments: ScreenArguments(
            incident_report: report,
            user: args.user,
          ),
        );
      }
    }

    goTo(int step) {
      setState(() => currentStep = step);
    }

    next() {
      currentStep + 1 != 2 ? goTo(currentStep + 1) : pushSummaryScreen();
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      } else {
        Navigator.pop(context);
      }
    }

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
        content: Form(
          key: form_keys[0],
          child: _buildDescription(args),
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
        content: Form(
          child: _buildLocation(),
        ),
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

  //build description step contents
  Widget _buildDescription(ScreenArguments args) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _buildIncidentTypeTextFormField(args),
        const SizedBox(height: 10),
        _buildVictimCheckBox(),
        const SizedBox(height: 10),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: not_victim
              ? Column(
                  children: [
                    _buildVictimNameTextFormField(),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildSexTextFormField(),
                        ),
                        SizedBox(width: 10),
                        SizedBox(
                          width: 120,
                          child: _buildAgeTextFormField(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : SizedBox.shrink(),
        ),
        _buildDescriptionTextFormField(),
        const SizedBox(height: 20),
        _buildIncidentImages(),
      ],
    );
  }

  //build location step contents
  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Row(
          children: [
            Text('Get location automatically'),
            Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: _switchValue
              ? SizedBox.shrink()
              : CustomTextFormField(
                  keyboardType: TextInputType.streetAddress,
                  prefixIcon: Icons.pin_drop_outlined,
                  label: 'Address',
                  onSaved: (val) {},
                ),
        ),
        SizedBox(height: 10),
        CustomTextFormField(
          keyboardType: TextInputType.streetAddress,
          prefixIcon: Icons.business_rounded,
          label: 'Landmark',
          onSaved: (val) {},
        ),
      ],
    );
  }

  Widget _buildIncidentTypeTextFormField(ScreenArguments args) {
    return CustomTextFormField(
      validator: sexValidator,
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.siren,
      label: 'Incident Type',
      onSaved: (val) {
        incident_type = val;
      },
      isReadOnly: true,
      initialValue: args.incidentType,
    );
  }

  Row _buildVictimCheckBox() {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: not_victim,
            onChanged: (value) {
              setState(() {
                not_victim = value!;
              });
            },
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              not_victim = !not_victim;
            });
          },
          child: Text(
            'I\'m not the victim',
            style: TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.description,
      validator: nameValidator,
      label: 'Description',
      onSaved: (String? val) {
        description = val;
      },
      maxLines: 5,
    );
  }

  Widget _buildVictimNameTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.description,
      validator: nameValidator,
      label: 'Victim Name',
      onSaved: (String? val) {
        patient_name = val;
      },
    );
  }

  Widget _buildSexTextFormField() {
    return CustomDropDownButton(
      hintText: 'Sex',
      icon: CustomIcons.sex,
      items: ['Male', 'Female'],
      onSaved: (val) {
        sex = val;
      },
      validator: (value) => value == null ? 'Sex is required' : null,
      isDisabled: false,
      focusNode: FocusNode(),
    );
  }

  Widget _buildAgeTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.number,
      prefixIcon: CustomIcons.age,
      validator: ageValidator,
      label: 'Age',
      onSaved: (String? val) {
        age = val;
      },
    );
  }

  Widget _buildIncidentImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Attach images of the incident',
            style: TextStyle(color: contentColorLightTheme),
            children: <InlineSpan>[
              TextSpan(
                text: ' (Optional)',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        SizedBox(height: 5),
        incident_images.length == 0
            ? InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: ((builder) => choosePhoto()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                ),
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 1,
                      color: contentColorLightTheme.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CustomIcons.add_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                      Text(
                        'Click here',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  clipBehavior: Clip.none,
                  children: displayIncidentImages(),
                ),
              ),
      ],
    );
  }

  Widget choosePhoto() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TextButton.icon(
            onPressed: () {
              takePhoto(ImageSource.gallery);
            },
            icon: Icon(
              Icons.photo,
              color: accentColor,
            ),
            label: Text(
              'Gallery',
              style: TextStyle(color: primaryColor),
            ),
          ),
          SizedBox(
            height: 50,
            child: VerticalDivider(
              width: 1,
              color: Colors.grey,
            ),
          ),
          TextButton.icon(
            onPressed: () {
              takePhoto(ImageSource.camera);
            },
            icon: Icon(
              Icons.camera,
              color: accentColor,
            ),
            label: Text(
              'Camera',
              style: TextStyle(color: primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    Navigator.pop(context);
    try {
      if (source == ImageSource.gallery) {
        List<XFile> selectedImages = (await _picker.pickMultiImage()) ?? [];
        if (selectedImages.isNotEmpty)
          setState(() {
            incident_images.addAll(selectedImages);
          });
      } else {
        final pickedFile = await _picker.pickImage(source: source) ?? null;
        if (pickedFile != null)
          setState(() {
            incident_images.add(pickedFile);
          });
      }
    } on Exception catch (e) {
      print('Error: $e');
    }
  }

  List<Widget> displayIncidentImages() {
    List<Widget> images = [];
    images.addAll(
      List.generate(
        incident_images.length,
        (index) {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: new Offset(-10, 10),
                      blurRadius: 20.0,
                      spreadRadius: 4.0,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(incident_images[index].path),
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        incident_images.removeAt(index);
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      size: 18.0,
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    images.add(
      InkWell(
        onTap: () => showModalBottomSheet(
          context: context,
          builder: ((builder) => choosePhoto()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        child: Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
            boxShadow: [
              new BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                offset: new Offset(-10, 10),
                blurRadius: 20.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            color: Colors.grey,
          ),
        ),
      ),
    );
    return images;
  }

  calculateAge(DateTime birthDate) {
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
    print(now);
    DateTime currentDate = DateTime.parse(now);
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
