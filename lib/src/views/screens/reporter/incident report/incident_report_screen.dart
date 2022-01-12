import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_gender_picker.dart';
import 'package:pers/src/widgets/custom_label.dart';
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
  bool toLocation = false;

  String? incident_type;
  String sex = 'Male';
  String? age;
  String? description;
  String? status;
  String? address;
  String? landmark;
  List<XFile> incident_images = [];

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final addressValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 10 characters is required'),
  ]);

  final landmarkValidator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(2, errorText: 'At least 8 characters is required'),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    incident_type = args.incidentType;
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
          key: form_keys[1],
          child: _buildLocation(),
        ),
        isActive: currentStep == 1,
        state: currentStep >= 1 ? StepState.editing : StepState.disabled,
      ),
    ];

    goTo(int step) {
      setState(() => currentStep = step);
    }

    next() async {
      if (currentStep == 0) {
        if (!toLocation && form_keys[0].currentState!.validate()) {
          form_keys[0].currentState!.save();
          print(incident_type);
          goTo(currentStep + 1);
        }
      } else {
        if (form_keys[1].currentState!.validate()) {
          form_keys[1].currentState!.save();

          if (_switchValue) {
            LocationData location_data = await Location().getLocation();
            address = '${location_data.longitude}, ${location_data.latitude}';
          }

          // get user credentials from shared preferences
          SharedPref pref = new SharedPref();
          User user = User.fromJson(await pref.read("user"));

          if (!not_victim) {
            print(user.toString());
            sex = user.sex!;
            age = calculateAge(DateTime.parse(user.birthday!)).toString();
            print(user.birthday!);
            print(age);
          }

          var report = IncidentReport(
            incident_type: incident_type,
            sex: sex,
            age: age,
            description: description,
            incident_images: incident_images,
            status: status,
            address: address,
            landmark: landmark,
            account_id: user.id.toString(),
          );

          print(report.toString());

          Navigator.pushNamed(
            context,
            '/reporter/home/report/summary',
            arguments: ScreenArguments(
              incident_report: report,
            ),
          );
        }
      }
    }

    cancel() {
      if (currentStep > 0) {
        goTo(currentStep - 1);
      } else {
        Navigator.pop(context);
      }
    }

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
      body: Stepper(
        steps: steps,
        currentStep: currentStep,
        onStepContinue: next,
        onStepCancel: cancel,
        onStepTapped: (step) => goTo(step),
        controlsBuilder: (BuildContext context,
            {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        onPressed: onStepContinue,
                        child: Text('Continue'),
                        style: ElevatedButton.styleFrom(
                          primary: accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
                currentStep == 0
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          SizedBox(width: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: TextButton(
                                onPressed: onStepCancel,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: accentColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  //build description step contents
  Widget _buildDescription(ScreenArguments args) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomLabel(label: 'Incident Type', value: args.incidentType!),
        ExpansionTile(
          title: Text('I\'m not the victim'),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildSexPicker()),
                const SizedBox(width: 10),
                SizedBox(
                  width: 110,
                  child: _buildAgeTextFormField(),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
          tilePadding: EdgeInsets.zero,
          trailing: Icon(
            not_victim ? Icons.circle : Icons.circle_outlined,
            size: 15,
          ),
          onExpansionChanged: (bool expanded) {
            setState(() => not_victim = expanded);
          },
        ),
        const SizedBox(height: 10),
        _buildVictimStatusTextFormField(),
        const SizedBox(height: 10),
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
            Text('Get my location automatically'),
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
                  validator: addressValidator,
                  keyboardType: TextInputType.streetAddress,
                  prefixIcon: Icons.pin_drop_outlined,
                  label: 'Address',
                  onSaved: (val) {
                    address = val;
                  },
                ),
        ),
        SizedBox(height: 10),
        CustomTextFormField(
          validator: landmarkValidator,
          keyboardType: TextInputType.streetAddress,
          prefixIcon: Icons.business_rounded,
          label: 'Landmark',
          onSaved: (val) {
            landmark = val;
          },
        ),
      ],
    );
  }

  Widget _buildSexPicker() {
    return CustomGenderPicker(
      onChanged: (val) {
        sex = val;
      },
    );
  }

  Widget _buildAgeTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.number,
      prefixIcon: CustomIcons.age,
      label: 'Age',
      onSaved: (val) {
        age = val;
      },
      validator: ageValidator,
    );
  }

  Widget _buildVictimStatusTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      prefixIcon: FontAwesomeIcons.questionCircle,
      validator: nameValidator,
      label: 'Victim Status',
      onSaved: (String? val) {
        status = val;
      },
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
                    width: 95,
                    height: 95,
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
          width: 95,
          height: 95,
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
