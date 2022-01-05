import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_gender_picker.dart';
import 'package:pers/src/widgets/custom_label.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class PersonalInformationScreen extends StatefulWidget {
  PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode bdayFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  TextEditingController bdateController = new TextEditingController();
  bool isLoading = false;

  User? user;

  String? first_name;
  String? last_name;
  String sex = 'Male';
  String? birthdate;
  String? mobile_no;

  bool readOnly = true;

  XFile? _imageFile;

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
  ]);

  final sexValidator = MultiValidator([
    RequiredValidator(errorText: 'Sex is required'),
  ]);

  final emailValidator = MultiValidator([
    EmailValidator(errorText: 'Invalid email address'),
    RequiredValidator(errorText: 'Email is required'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'Passwords must have at least one special character'),
  ]);

  final mobileNoValidator = MultiValidator([
    RequiredValidator(errorText: 'Mobile number is required.'),
    PhoneValidator(),
  ]);

  final birthdateValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    DateValidator('yyyy-MM-dd', errorText: 'Birthdate is required.'),
  ]);

  _saveEdits(String field, String value) async {
    // get bearer token from shared preferences
    SharedPref pref = new SharedPref();
    String token = await pref.read("token");

    String url = "http://143.198.92.250/api/accounts/${user!.id}";
    Map body = {"$field": value};

    Map<String, dynamic> jsonResponse;

    var res = await http.put(Uri.parse(url), body: body, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      jsonResponse = jsonDecode(res.body);
      if (jsonResponse != null) {
        SharedPref preferences = SharedPref();

        User user = User.fromMap(jsonResponse);

        // save user credentials inside local storage
        preferences.save("user", user);
        setState(() {
          preferences.reload();
        });
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print(res.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Information',
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (!readOnly) {
                setState(() {
                  isLoading = true;
                });
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (user!.first_name != first_name) {
                    _saveEdits('first_name', first_name!);
                  }
                  if (user!.last_name != last_name) {
                    _saveEdits('last_name', last_name!);
                  }
                  if (user!.sex != sex) {
                    _saveEdits('sex', sex);
                  }
                  if (user!.birthday != birthdate) {
                    _saveEdits('birthday', birthdate!);
                  }
                  setState(() {
                    readOnly = true;
                  });
                  setState(() {
                    isLoading = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: new Text('Profile successfuly updated'),
                      backgroundColor: Colors.green,
                      duration: new Duration(seconds: 3),
                    ),
                  );
                }
              } else {
                setState(() {
                  readOnly = false;
                });
              }
            },
            child: Text(
              readOnly ? 'Edit' : 'Save',
              style: TextStyle(
                color: accentColor,
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        Widget loadingIndicator = isLoading
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
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  buildColumn(),
                  new Align(
                    child: loadingIndicator,
                    alignment: FractionalOffset.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildColumn() => FutureBuilder(
      future: SharedPref().read('user'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = User.fromJson(snapshot.data as String);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      buildTopContainer(user!),
                      buildBottomContainer(user!),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else
          return Text('');
      });

  Widget buildTopContainer(User user) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                ClipOval(
                  child: Material(
                    color: chromeColor.withOpacity(0.5),
                    child: Ink.image(
                      image: _imageFile == null
                          ? AssetImage('assets/images/avatar-image.png')
                          : FileImage(File(_imageFile!.path)) as ImageProvider,
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                      child: InkWell(
                        onTap: () {
                          readOnly
                              ? () {}
                              : showModalBottomSheet(
                                  context: context,
                                  builder: (builder) => choosePhoto(),
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
                  right: 4,
                  child:
                      readOnly ? SizedBox.shrink() : buildEditIcon(Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              '${user.first_name} ${user.last_name}',
              style: DefaultTextTheme.headline3,
            ),
            Text(
              '${user.email}',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomContainer(User user) {
    return Expanded(
      child: readOnly ? _displayPersonalInfo(user) : _editPersonalInfo(user),
    );
  }

  Widget _displayPersonalInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        CustomLabel(
          label: 'First Name',
          value: user.first_name!,
        ),
        const SizedBox(height: 5),
        CustomLabel(label: 'Last Name', value: user.last_name!),
        const SizedBox(height: 5),
        CustomLabel(label: 'Sex', value: user.sex!),
        const SizedBox(height: 5),
        CustomLabel(label: 'Birthday', value: user.birthday!),
        const SizedBox(height: 5),
        ChangePasswordButton(),
      ],
    );
  }

  Widget _editPersonalInfo(User user) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          FirstNameTextField(user.first_name!),
          const SizedBox(height: 5),
          LastNameTextField(user.last_name!),
          const SizedBox(height: 5),
          CustomGenderPicker(
            initialValue: user.sex == 'Male' ? 0 : 1,
            onChanged: (val) {
              sex = val;
            },
          ),
          const SizedBox(height: 5),
          BirthDatePicker(user.birthday!),
          const SizedBox(height: 5),
          ChangePasswordButton(),
        ],
      ),
    );
  }

  Widget FirstNameTextField(String first_name) {
    return CustomTextFormField(
      validator: nameValidator,
      keyboardType: TextInputType.name,
      label: 'First Name',
      onSaved: (value) {
        this.first_name = value!.trim();
      },
      initialValue: first_name,
      prefixIcon: CustomIcons.person,
      isReadOnly: readOnly,
    );
  }

  Widget LastNameTextField(String last_name) {
    return CustomTextFormField(
      validator: nameValidator,
      label: 'Last Name',
      onSaved: (value) {
        this.last_name = value!.trim();
      },
      initialValue: last_name,
      prefixIcon: CustomIcons.person,
      keyboardType: TextInputType.name,
      isReadOnly: readOnly,
    );
  }

  Widget GenderDropDown(String _sex) {
    return CustomDropDownButton(
      hintText: 'Sex',
      icon: CustomIcons.sex,
      focusNode: bdayFocusNode,
      items: ['Male', 'Female'],
      onSaved: (val) {
        this.sex = val!.trim();
      },
      validator: (value) => value == null ? 'Sex is required' : null,
      isDisabled: readOnly,
    );
  }

  Widget BirthDatePicker(String birthday) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: CustomTextFormField(
            controller: bdateController,
            label: 'Birthdate',
            keyboardType: TextInputType.datetime,
            isReadOnly: true,
            prefixIcon: CustomIcons.calendar,
            initialValue: birthday,
            onSaved: (newValue) {
              this.birthdate = newValue!.trim();
            },
            validator: birthdateValidator,
          ),
        ),
        readOnly
            ? SizedBox.shrink()
            : Row(
                children: [
                  SizedBox(width: 10),
                  Column(
                    children: [
                      Text(''),
                      Container(
                        width: 80,
                        child: OutlinedButton(
                          focusNode: bdayFocusNode,
                          onPressed: readOnly ? null : _showDatePicker,
                          child: Text('Set'),
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                EdgeInsets.all(22),
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }

  Widget ChangePasswordButton() {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/reporter/home/profile/new_password');
      },
      child: Text('Change Password'),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 5,
          child: Icon(
            Icons.edit,
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

  void _showDatePicker() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    print(DateTime.now().year);
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    ).then((d) {
      setState(() {
        DateTime date = d!;
        birthdate = formatter.format(date);
        bdateController.text = birthdate!;
      });
      mobileFocusNode.requestFocus();
    });
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
    Navigator.pop(context);
    ImagePicker _picker = new ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null)
      setState(() {
        _imageFile = pickedFile;
      });
  }
}
