import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/phone_validator.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_dropdown_button.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class PersonalInformationScreen extends StatefulWidget {
  PersonalInformationScreen({Key? key}) : super(key: key);

  @override
  _PersonalInformationScreenState createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  FocusNode bdayFocusNode = new FocusNode();
  FocusNode mobileFocusNode = new FocusNode();
  TextEditingController bdateController = new TextEditingController();

  String? first_name;
  String? last_name;
  String? sex;
  String birthdate = 'Birthdate';
  String? mobile_no;

  bool readOnly = true;

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
        centerTitle: true,
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: buildColumn(),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTopContainer(),
          buildBottomContainer(),
        ],
      );

  Widget buildTopContainer() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                ClipOval(
                  child: Material(
                    child: Ink.image(
                      image: NetworkImage(
                        'https://bit.ly/3lD1cKX',
                      ),
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                      child: InkWell(
                        onTap: () {},
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              'Juan Dela Cruz',
              style: DefaultTextTheme.headline3,
            ),
            Text(
              'juandelacruz@gmail.com',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomContainer() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          FirstNameTextField(),
          const SizedBox(height: 15),
          LastNameTextField(),
          const SizedBox(height: 15),
          GenderDropDown(),
          const SizedBox(height: 15),
          BirthDatePicker(),
          const SizedBox(height: 30),
          UpdateProfileButton(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget FirstNameTextField() {
    return CustomTextFormField(
      validator: nameValidator,
      keyboardType: TextInputType.name,
      label: 'First Name',
      onSaved: (value) {
        if (value != null) first_name = value.trim();
      },
      prefixIcon: CustomIcons.person,
      isReadOnly: readOnly,
    );
  }

  Widget LastNameTextField() {
    return CustomTextFormField(
      validator: nameValidator,
      label: 'Last Name',
      onSaved: (value) {
        if (value != null) last_name = value.trim();
      },
      prefixIcon: CustomIcons.person,
      keyboardType: TextInputType.name,
      isReadOnly: readOnly,
    );
  }

  Widget GenderDropDown() {
    return CustomDropDownButton(
      hintText: 'Sex',
      icon: CustomIcons.sex,
      focusNode: bdayFocusNode,
      items: ['Male', 'Female'],
      onSaved: (val) {
        sex = val;
      },
      validator: (value) => value == null ? 'Sex is required' : null,
      isDisabled: readOnly,
    );
  }

  Widget BirthDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 3,
          child: CustomTextFormField(
            key: Key(birthdate),
            controller: bdateController,
            label: 'Birthdate',
            keyboardType: TextInputType.datetime,
            isReadOnly: true,
            prefixIcon: CustomIcons.calendar,
            initialValue: birthdate,
            onSaved: (newValue) {
              birthdate = newValue!;
            },
            validator: birthdateValidator,
          ),
        ),
        SizedBox(
          width: 10,
        ),
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
                    EdgeInsets.all(20),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    Colors.white,
                  ),
                ),
              ),
            ),
          ],
        )
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

  Widget UpdateProfileButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            readOnly = false;
          });
        },
        child: Text('Update Profile'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(accentColor),
        ),
      ),
    );
  }

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
        bdateController.text = birthdate;
      });
      mobileFocusNode.requestFocus();
    });
  }
}
