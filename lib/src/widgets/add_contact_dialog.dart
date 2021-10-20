import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class AddContactDialog extends StatefulWidget {
  AddContactDialog({Key? key}) : super(key: key);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final mobileNoValidator = MultiValidator([
    RequiredValidator(errorText: 'Mobile number is required.'),
    PhoneValidator(),
  ]);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Add Emergency Contact',
                      style: DefaultTextTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Stack(
                      children: <Widget>[
                        ClipOval(
                          child: Material(
                            color: chromeColor.withOpacity(0.5),
                            child: Ink.image(
                              image: _imageFile == null
                                  ? AssetImage('assets/images/avatar-image.png')
                                  : FileImage(File(_imageFile!.path))
                                      as ImageProvider,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => choosePhoto()),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 5,
                          child: buildEditIcon(Colors.blue),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    keyboardType: TextInputType.name,
                    prefixIcon: CustomIcons.person,
                    validator: nameValidator,
                    label: 'Name',
                    onSaved: (val) {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    prefixIcon: CustomIcons.telephone,
                    validator: mobileNoValidator,
                    label: 'Mobile Number',
                    onSaved: (val) {},
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add Contact'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(accentColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 16,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
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
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
}
