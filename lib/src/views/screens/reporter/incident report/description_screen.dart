import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class DescriptionScreen extends StatefulWidget {
  DescriptionScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  List<XFile> incidentImages = [];

  final _formKey = GlobalKey<FormState>();
  bool _load = false;

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Fill this in too'),
    MinLengthValidator(10, errorText: 'At least 10 characters is required'),
  ]);

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

  Widget _buildTopContainer(ScreenArguments args) => Expanded(
        child: SingleChildScrollView(
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
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: CustomIcons.siren,
                  validator: validator,
                  label: 'Incident Type',
                  onSaved: (val) {},
                  isReadOnly: true,
                  initialValue: args.incidentType,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  keyboardType: TextInputType.text,
                  prefixIcon: CustomIcons.description,
                  validator: validator,
                  label: 'Description',
                  onSaved: (val) {},
                  maxLines: 5,
                ),
                const SizedBox(height: 20),
                Text(
                  'Attach images of the incident (Optional)',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 5),
                incidentImages.length == 0
                    ? GestureDetector(
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
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: contentColorLightTheme.withOpacity(0.2),
                            ),
                          ),
                          child: Icon(
                            CustomIcons.add_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 120,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemBuilder: (BuildContext context, index) {
                            return SizedBox(
                              width: 50,
                              height: 50,
                              child: Image(
                                image:
                                    FileImage(File(incidentImages[index].path))
                                        as ImageProvider,
                              ),
                            );
                          },
                          itemCount: incidentImages.length,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );

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

    if (source == ImageSource.gallery) {
      List<XFile> selectedImages = (await _picker.pickMultiImage())!;
      setState(() {
        incidentImages.addAll(selectedImages);
      });
      return;
    }
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      incidentImages.add(pickedFile!);
    });
    Navigator.pop(context);
  }
}
