import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/incident_report.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class DescriptionScreen extends StatefulWidget {
  DescriptionScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool not_victim = false;

  late TextEditingController controller;

  final _formKey = GlobalKey<FormState>();
  bool _load = false;

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
  void initState() {
    controller = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    Widget loadingIndicator = _load
        ? new Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: new Padding(
              padding: const EdgeInsets.all(5.0),
              child: new Center(
                child: new CircularProgressIndicator(),
              ),
            ),
          )
        : new Container();

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    clipBehavior: Clip.none,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: _buildColumn(args),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }

  Widget _buildColumn(ScreenArguments args) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopContainer(args),
          _buildBottomContainer(args),
        ],
      );

  Widget _buildTopContainer(ScreenArguments args) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Incident Description',
                style: DefaultTextTheme.headline3,
              ),
              Text(
                'Please provide the specific details of the incident',
                style: DefaultTextTheme.subtitle1,
              ),
              const SizedBox(height: 30),
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
          ),
        ),
      ),
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

  Widget _buildBottomContainer(ScreenArguments args) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(
                  'Back',
                  style: TextStyle(
                    color: primaryColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: primaryColor,
                ),
              ),
            ),
            SizedBox(width: 10),
            SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    //if reporter is the victim then retrieve patient name, sex and age information to his profile.
                    if (!not_victim) {
                      patient_name =
                          '${args.user!.first_name!} ${args.user!.last_name!}';
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
                    );

                    Navigator.of(context).pushNamed(
                      '/reporter/home/report/location',
                      arguments: ScreenArguments(
                        incident_report: report,
                        user: args.user,
                      ),
                    );
                  }
                },
                child: Text('Continue'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(accentColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

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
