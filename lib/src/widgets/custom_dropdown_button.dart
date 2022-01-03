import 'package:flutter/material.dart';
import 'package:pers/src/custom_icons.dart';
import 'package:pers/src/constants.dart';

class CustomDropDownButton extends StatefulWidget {
  final List<String> items;
  final IconData icon;
  final String hintText;
  final FocusNode? focusNode;
  final FormFieldValidator validator;
  final FormFieldSetter<String>? onSaved;
  final bool isDisabled;
  final bool isOptional;

  const CustomDropDownButton({
    required this.items,
    required this.icon,
    required this.hintText,
    required this.validator,
    required this.onSaved,
    this.focusNode,
    this.isDisabled = false,
    this.isOptional = false,
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
        Text.rich(
          TextSpan(
            text: widget.hintText,
            style: TextStyle(color: contentColorLightTheme),
            children: <InlineSpan>[
              widget.isOptional
                  ? TextSpan(
                      text: ' (Optional)',
                      style: TextStyle(color: Colors.grey),
                    )
                  : TextSpan(),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: DropdownButtonFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: widget.validator,
            onSaved: widget.onSaved,
            decoration: InputDecoration(
              prefixIcon: Icon(
                CustomIcons.sex,
                color: contentColorLightTheme,
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: contentColorLightTheme.withOpacity(0.2),
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: contentColorLightTheme.withOpacity(0.2),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.redAccent,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: chromeColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5.5),
              ),
              filled: true,
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
                : (String? val) {
                    setState(() {
                      dropdownValue = val;
                      isTapped = !isTapped;
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
