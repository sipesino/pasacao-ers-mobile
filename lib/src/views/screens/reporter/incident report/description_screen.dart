import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
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
  List<XFile> incidentImages = [];
  bool not_victim = false;

  late TextEditingController controller;

  final _formKey = GlobalKey<FormState>();
  bool _load = false;

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
    RequiredValidator(errorText: 'Fill this in too'),
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
          _buildBottomContainer(),
        ],
      );

  Widget _buildTopContainer(ScreenArguments args) {
    return Expanded(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Incident Description',
                style: DefaultTextTheme.headline2,
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
                duration: Duration(milliseconds: 400),
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
      onSaved: (val) {},
      maxLines: 5,
    );
  }

  Widget _buildVictimNameTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.description,
      validator: nameValidator,
      label: 'Victim Name',
      onSaved: (val) {},
      isOptional: true,
    );
  }

  Widget _buildSexTextFormField() {
    return CustomDropDownButton(
      hintText: 'Sex',
      icon: CustomIcons.sex,
      validator: sexValidator,
      onSaved: (val) {},
      focusNode: FocusNode(),
      items: [
        'Male',
        'Female',
      ],
      isOptional: true,
    );
  }

  Widget _buildAgeTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.number,
      prefixIcon: CustomIcons.age,
      validator: ageValidator,
      label: 'Age',
      onSaved: (val) {},
      isOptional: true,
    );
  }

  Widget _buildIncidentTypeTextFormField(ScreenArguments args) {
    return CustomTextFormField(
      keyboardType: TextInputType.text,
      prefixIcon: CustomIcons.siren,
      label: 'Incident Type',
      onSaved: (val) {},
      isReadOnly: true,
      initialValue: args.incidentType,
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
        incidentImages.length == 0
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
            : Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 10,
                    runSpacing: 10,
                    clipBehavior: Clip.none,
                    children: displayIncidentImages(),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildBottomContainer() => SizedBox.fromSize(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                width: 100,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_left,
                        color: primaryColor,
                      ),
                      Text(
                        'Back',
                        style: TextStyle(
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                height: 50,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/reporter/home/report/location',
                      arguments: ScreenArguments(),
                    );
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
            incidentImages.addAll(selectedImages);
          });
      } else {
        final pickedFile = await _picker.pickImage(source: source) ?? null;
        if (pickedFile != null)
          setState(() {
            incidentImages.add(pickedFile);
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
        incidentImages.length,
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
                    File(incidentImages[index].path),
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
                        incidentImages.removeAt(index);
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
}
