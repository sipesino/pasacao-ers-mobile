import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<String> items;
  final IconData icon;
  final String hintText;
  final FocusNode focusNode;
  final FormFieldValidator validator;
  final FormFieldSetter<String>? onSaved;
  final bool isDisabled;

  const CustomDropDownButton({
    required this.items,
    required this.icon,
    required this.hintText,
    required this.focusNode,
    required this.validator,
    required this.onSaved,
    required this.isDisabled,
  });

  @override
  State<CustomDropDownButton> createState() => _CustomDropDownButtonState();
}

class _CustomDropDownButtonState extends State<CustomDropDownButton> {
  String? dropdownValue;
  bool isTapped = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sex',
          style: TextStyle(color: contentColorLightTheme),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: isTapped
                  ? contentColorLightTheme.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<String>(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onSaved: widget.onSaved,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              focusedBorder: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              icon: Icon(
                CustomIcons.sex,
                color: contentColorLightTheme,
                size: 20,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: -4),
              enabledBorder: InputBorder.none,
            ),
            autofocus: false,
            iconEnabledColor: contentColorLightTheme,
            isExpanded: true,
            value: dropdownValue,
            iconSize: 20,
            icon: Icon(Icons.keyboard_arrow_down),
            items: widget.items.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: contentColorLightTheme,
                  ),
                ),
              );
            }).toList(),
            onChanged: widget.isDisabled
                ? null
                : (newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      isTapped = !isTapped;
                      widget.focusNode.requestFocus();
                    });
                  },
            onTap: () {
              setState(() {
                isTapped = !isTapped;
              });
            },
          ),
        ),
      ],
    );
  }
}
