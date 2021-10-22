import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/data/data.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class AddContactDialog extends StatefulWidget {
  final bool editContact;
  final String contact_name;
  final String contact_number;
  final String contact_image;
  final int index;
  AddContactDialog({
    Key? key,
    this.editContact = false,
    this.contact_name = '',
    this.contact_number = '',
    this.contact_image = '',
    this.index = 0,
  }) : super(key: key);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  bool _load = false;
  XFile? _imageFile;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final mobileNoValidator = MultiValidator([
    RequiredValidator(errorText: 'Mobile number is required.'),
    PhoneValidator(),
  ]);

  //form field values
  String? contact_name;
  String? contact_number;
  String? contact_image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contact_image = widget.editContact
        ? widget.contact_image
        : 'assets/images/avatar-image.png';
  }

  @override
  Widget build(BuildContext context) {
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
        Dialog(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            widget.editContact
                                ? 'Edit Emergency Contact'
                                : 'Add Emergency Contact',
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
                                    image: widget.editContact
                                        ? AssetImage(widget.contact_image)
                                        : _imageFile == null
                                            ? AssetImage(
                                                'assets/images/avatar-image.png')
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
                          initialValue:
                              widget.editContact ? widget.contact_name : '',
                          onSaved: (val) {
                            contact_name = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                          keyboardType: TextInputType.phone,
                          prefixIcon: CustomIcons.telephone,
                          validator: mobileNoValidator,
                          label: 'Mobile Number',
                          initialValue:
                              widget.editContact ? widget.contact_number : '',
                          onSaved: (val) {
                            contact_number = val;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                if (widget.editContact) {
                                  Navigator.pop(context);
                                  setState(() {
                                    editEmergencyContact(
                                      new EmergencyContact(
                                        contact_name: contact_name!,
                                        contact_number: contact_number!,
                                        contact_image: contact_image!,
                                      ),
                                      widget.index,
                                    );
                                  });
                                } else {
                                  setState(() {
                                    _load = true;
                                    addEmergencyContacts(
                                      EmergencyContact(
                                        contact_name: contact_name!,
                                        contact_number: contact_number!,
                                        contact_image: contact_image!,
                                      ),
                                    );
                                  });
                                  setState(() {
                                    _load = false;
                                  });
                                  Navigator.pop(context);
                                }
                              }
                            },
                            child: Text(
                              widget.editContact ? 'Save' : 'Add Contact',
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(accentColor),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
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
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
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
    Navigator.pop(context);
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null)
      setState(() {
        _imageFile = pickedFile;
      });
  }
}
