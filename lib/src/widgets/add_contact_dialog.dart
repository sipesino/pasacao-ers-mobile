import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class AddContactDialog extends StatefulWidget {
  final bool editContact;
  final String contact_name;
  final String contact_image;
  final String contact_number;
  final int contact_id;
  final int index;
  Function()? notify_parent;
  AddContactDialog({
    Key? key,
    this.editContact = false,
    this.contact_name = '',
    this.contact_number = '',
    this.contact_image = '',
    this.index = 0,
    this.notify_parent,
    this.contact_id = 0,
  }) : super(key: key);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  List<EmergencyContact> contacts = [];
  final _formKey = GlobalKey<FormState>();
  bool _load = false;

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
  int? contact_id;

  @override
  void initState() {
    super.initState();

    SharedPref().read('contacts').then((value) {
      if (value != 'null')
        contacts = EmergencyContact.decode(value);
      else
        print('>>> No emergency contacts');
    });
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
                    borderRadius: BorderRadius.circular(10),
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
                          height: 10,
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
                                  editEmergencyContact(
                                    new EmergencyContact(
                                      contact_name: contact_name!,
                                      contact_number: contact_number!,
                                      contact_id: contact_id!,
                                    ),
                                    widget.index,
                                  );
                                } else {
                                  addEmergencyContacts(
                                    EmergencyContact(
                                      contact_name: contact_name!,
                                      contact_number: contact_number!,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              widget.editContact ? 'Save' : 'Add Contact',
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(accentColor),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
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

  addEmergencyContacts(EmergencyContact contact) async {
    final Connectivity _connectivity = Connectivity();

    _connectivity.checkConnectivity().then((status) async {
      ConnectivityResult _connectionStatus = status;

      if (_connectionStatus != ConnectivityResult.none) {
        User user;
        SharedPref pref = new SharedPref();
        String token = await pref.read("token");

        user = User.fromJson(await pref.read('user'));
        String url = 'http://143.198.92.250/api/emergencycontacts';

        Map<String, dynamic> body = {
          "contact_name": contact.contact_name,
          "contact_number": contact.contact_number,
          "account_id": user.id.toString(),
        };

        var res = await http.post(
          Uri.parse(url),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (res.statusCode == 200) {
          var jsonResponse = jsonDecode(res.body);

          EmergencyContact contact =
              EmergencyContact.fromMap(jsonResponse["data"]);

          contacts.add(contact);
          final String encoded_contacts = EmergencyContact.encode(contacts);
          SharedPref().save('contacts', encoded_contacts);
          widget.notify_parent!();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: new Text("Emergency contact added successfuly."),
              backgroundColor: Colors.green,
              duration: new Duration(seconds: 5),
            ),
          );
        }
        res.statusCode;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: new Text("No internet connection."),
            backgroundColor: Colors.red,
            duration: new Duration(seconds: 5),
          ),
        );
      }
    });
  }

  editEmergencyContact(EmergencyContact contact, int index) {
    contacts[index] = contact;
    final String encoded_contacts = EmergencyContact.encode(contacts);
    SharedPref().save('contacts', encoded_contacts);
    Navigator.pop(context);
  }
}
