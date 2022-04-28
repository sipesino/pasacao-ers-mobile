import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/emergency_contact.dart';
import 'package:pers/src/models/locations.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/models/shared_prefs.dart';
import 'package:pers/src/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:pers/src/widgets/custom_gender_picker.dart';
import 'package:pers/src/widgets/custom_label.dart';
import 'package:pers/src/widgets/custom_status_picker%20copy.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({Key? key}) : super(key: key);

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  int currentStep = 0;

  final GlobalKey<FormState> form_key = GlobalKey<FormState>();

  bool not_victim = false;
  bool toLocation = false;
  bool isLoading = false;

  String? name;
  String? incident_type;
  String sex = 'Male';
  String? age;
  String? description;
  String? victim_status;
  String? longitude;
  String? latitude;
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
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    incident_type = args.incidentType;

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

    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Incident Report',
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Stack(
          children: [
            Form(
              key: form_key,
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Hero(
                          tag: '${args.incidentType!}-icon',
                          child: Icon(
                            args.icon,
                            size: 30,
                            color: accentColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      CustomLabel(
                        label: 'Incident Type',
                        value: args.incidentType!,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildNotVictimCheckbox(),
                  const SizedBox(height: 10),
                  _buildNotVictimFields(),
                  _buildDescriptionTextFormField(),
                  const SizedBox(height: 20),
                  _buildLandmarkTextFormField(),
                  const SizedBox(height: 10),
                  Text(
                    'Note: Your location is automatically detected.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitReportButton(context),
                ],
              ),
            ),
            Center(child: loadingIndicator),
          ],
        ),
      ),
    );
  }

  Row _buildNotVictimCheckbox() {
    return Row(
      children: [
        SizedBox(
          height: 20.0,
          width: 20.0,
          child: Checkbox(
            value: not_victim,
            onChanged: (val) {
              setState(() {
                not_victim = val!;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
        SizedBox(width: 10),
        TextButton(
          onPressed: () {
            setState(() {
              not_victim = !not_victim;
            });
          },
          child: Text('I\'m not the victim'),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(50, 30),
            alignment: Alignment.centerLeft,
          ),
        )
      ],
    );
  }

  SizedBox _buildSubmitReportButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          _submitReport();
        },
        child: Text('Submit Report'),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(accentColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  AnimatedSwitcher _buildNotVictimFields() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: not_victim
          ? Column(
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
                const SizedBox(height: 10),
                _buildVictimvictim_statusPicker(),
                const SizedBox(height: 10),
              ],
            )
          : SizedBox.shrink(),
    );
  }

  _submitReport() async {
    if (form_key.currentState!.validate()) {
      form_key.currentState!.save();
      final Connectivity _connectivity = Connectivity();

      _connectivity.checkConnectivity().then((status) async {
        ConnectivityResult _connectionStatus = status;
        setState(() {
          isLoading = true;
        });
        //get user location coordinates
        LocationData location_data = await Location().getLocation();
        longitude = '${location_data.longitude}';
        latitude = '${location_data.latitude}';

        User user = User.fromJson(await SharedPref().read("user"));

        if (!not_victim) {
          name = "${user.first_name} ${user.last_name}";
          sex = user.sex!;
          age = calculateAge(DateTime.parse(user.birthday!)).toString();
          victim_status = 'Conscious';
        }

        if (_connectionStatus != ConnectivityResult.none) {
          print('>>> Internet connection detected.');

          // get user credentials from shared preferences
          SharedPref pref = new SharedPref();
          String token = await pref.read("token");

          String url = 'http://143.198.92.250/api/locations';

          Map<String, dynamic> location_body = {
            "location_type": "incident location",
            "longitude": longitude,
            "latitude": latitude,
            "landmark": landmark,
          };

          print(location_body);

          var res = await http.post(
            Uri.parse(url),
            body: location_body,
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (res.statusCode == 200) {
            print('Location inserted');
            var jsonResponse = jsonDecode(res.body);

            LocationInfo location_info =
                LocationInfo.fromMap(jsonResponse["data"]);

            String url = 'http://143.198.92.250/api/incidents';

            Map<String, dynamic> body = {
              "incident_type": incident_type,
              "sex": sex,
              "age": age,
              "incident_status": "pending",
              "victim_status": victim_status!.toLowerCase(),
              "description": description,
              "account_id": user.id.toString(),
              "location_id": location_info.location_id.toString(),
              "landmark": landmark,
            };

            print(body);

            res = await http.post(
              Uri.parse(url),
              body: body,
              headers: {
                'Authorization': 'Bearer $token',
                "Connection": "Keep-Alive",
                "Keep-Alive": "timeout=5, max=1000",
              },
            );
            if (res.statusCode == 200) {
              jsonResponse = jsonDecode(res.body);
              setState(() {
                isLoading = false;
              });

              if (jsonResponse != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: new Text("Incident reported successfuly."),
                    backgroundColor: Colors.green,
                    duration: new Duration(seconds: 5),
                  ),
                );
                await showSendToContactsDialog();
                Navigator.of(context).pop();
                return;
              }
            } else {
              print(res.statusCode);
            }
          }
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: new Text("Something went wrong."),
              backgroundColor: Colors.red,
              duration: new Duration(seconds: 5),
            ),
          );

          print(res.statusCode);
          print(res.body);
        } else {
          showNoInternetDialog();
        }
      });
    }
  }

  CustomTextFormField _buildLandmarkTextFormField() {
    return CustomTextFormField(
      keyboardType: TextInputType.streetAddress,
      prefixIcon: Icons.business_rounded,
      label: 'Landmark',
      isOptional: true,
      onSaved: (val) {
        landmark = val;
      },
    );
  }

  Widget _buildSexPicker() {
    return CustomGenderPicker(
      onChanged: (val) {
        sex = val;
      },
    );
  }

  Widget _buildVictimvictim_statusPicker() {
    return CustomStatusPicker(
      onChanged: (val) {
        victim_status = val;
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

  Widget NameTextField() {
    return CustomTextFormField(
      keyboardType: TextInputType.name,
      label: 'Victim Name',
      onSaved: (value) {
        if (value != null) name = value.trim();
      },
      isOptional: true,
      prefixIcon: CustomIcons.person,
    );
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

  Future<void> showNoInternetDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No internet detected.'),
          content: Text('Do you want to send your report as SMS?'),
          actions: [
            TextButton(
              onPressed: () {
                String message =
                    "New Incident Report:\nIncident Type: $incident_type\nSex: $sex\nAge: $age\nVictim Status: $victim_status\nDescription: $description\nLocation: $latitude, $longitude";
                print('>>> Sending message...');
                _sendSMS(message, ['09296871657']);
                print('>>> Message sent.');
                setState(() {
                  isLoading = false;
                });
              },
              child: Text(
                'YES',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSendToContactsDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Incident Report.'),
          content: Text('Do you want to notify your emergency contacts?'),
          actions: [
            TextButton(
              onPressed: () {
                SharedPref().read('contacts').then((value) {
                  print(value);
                  String message =
                      "Emergency Alert:\nI encoutered $incident_type in these coordinates: $latitude, $longitude. Dae ko aram ang sasabihon ko igdi";
                  if (value != 'null') {
                    List<EmergencyContact> contacts =
                        EmergencyContact.decode(value);
                    List<String> recepients = [];
                    contacts.forEach((EmergencyContact element) =>
                        recepients.add(element.contact_number));
                    _sendSMS(message, recepients);
                  } else {
                    print('You have no contacts');
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'YES',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
