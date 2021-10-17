import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/models/screen_arguments.dart';
import 'package:pers/src/theme.dart';
import 'package:pers/src/widgets/custom_text_form_field.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({Key? key}) : super(key: key);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _load = false;

  final validator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'At least 2 characters is required'),
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
                return SingleChildScrollView(
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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text(
                'Incident Report Summary',
                style: DefaultTextTheme.headline2,
              ),
              Text(
                'Please review all the information stated below',
                style: DefaultTextTheme.subtitle1,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                prefixIcon: CustomIcons.person,
                validator: validator,
                label: 'Reporter Name',
                onSaved: (val) {},
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      keyboardType: TextInputType.name,
                      prefixIcon: CustomIcons.sex,
                      validator: validator,
                      label: 'Sex',
                      onSaved: (val) {},
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: CustomTextFormField(
                      keyboardType: TextInputType.name,
                      prefixIcon: CustomIcons.age,
                      validator: validator,
                      label: 'Age',
                      onSaved: (val) {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                prefixIcon: CustomIcons.siren,
                validator: validator,
                label: 'Incident Type',
                onSaved: (val) {},
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                prefixIcon: CustomIcons.description,
                validator: validator,
                label: 'Description',
                onSaved: (val) {},
                maxLines: 3,
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 1,
                  scrollDirection: Axis.horizontal,
                  children: [],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                prefixIcon: CustomIcons.description,
                validator: validator,
                label: 'Location',
                onSaved: (val) {},
              ),
            ],
          ),
        ),
      );

  Widget _buildBottomContainer() => SizedBox(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
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
                  onPressed: () {},
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
}
