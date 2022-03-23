import 'package:flutter/material.dart';
import 'package:pers/src/constants.dart';

class CustomGenderPicker extends StatefulWidget {
  int initialValue;
  FormFieldValidator<String>? validator;

  final Function(String) onChanged;
  CustomGenderPicker({
    Key? key,
    required this.onChanged,
    this.initialValue = 0,
  }) : super(key: key);

  @override
  _CustomGenderPickerState createState() => _CustomGenderPickerState();
}

class _CustomGenderPickerState extends State<CustomGenderPicker> {
  int selected = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != 0) {
      selected = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sex'),
        SizedBox(height: 5),
        Row(
          children: [
            CustomRadioButton('Male', 0),
            SizedBox(width: 10),
            CustomRadioButton('Female', 1),
          ],
        ),
      ],
    );
  }

  Widget CustomRadioButton(String text, int index) => OutlinedButton(
        onPressed: () {
          setState(() {
            selected = index;
            widget.onChanged(selected == 0 ? 'Male' : 'Female');
          });
        },
        child: Text(
          text,
          style: TextStyle(
            color: (selected == index) ? accentColor : Colors.black,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: (selected == index)
                ? accentColor
                : contentColorLightTheme.withOpacity(0.2),
          ),
        ),
      );
}
