import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class DescriptionScreen extends StatefulWidget {
  final ScreenArguments args;
  DescriptionScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  bool not_victim = false;

  late TextEditingController controller;

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
    return Form(
      key: widget.form_key,
      child: _buildColumn(),
    );
  }

  Widget _buildColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        _buildIncidentTypeTextFormField(),
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

  Widget _buildIncidentTypeTextFormField() {
    return CustomTextFormField(
      validator: sexValidator,
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.siren,
      label: 'Incident Type',
      onSaved: (val) {
        incident_type = val;
      },
      isReadOnly: true,
      initialValue: widget.args.incidentType,
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
