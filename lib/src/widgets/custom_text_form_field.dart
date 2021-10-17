import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';

class CustomTextFormField extends StatefulWidget {
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final FormFieldValidator validator;
  final String label;
  final int? maxLines;
  final FormFieldSetter<String>? onSaved;
  final TextInputAction inputAction;
  final FocusNode? focusNode;
  final bool isReadOnly;
  final TextEditingController? controller;
  final String? initialValue;
  final VoidCallback? onTap;
  final Key? key;

  CustomTextFormField({
    required this.keyboardType,
    required this.prefixIcon,
    required this.validator,
    required this.label,
    required this.onSaved,
    this.maxLines = 1,
    this.focusNode,
    this.controller,
    this.inputAction = TextInputAction.next,
    this.isReadOnly = false,
    this.initialValue,
    this.onTap,
    this.key,
  }) : super(key: key);

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(color: contentColorLightTheme),
          ),
          SizedBox(height: 5),
          TextFormField(
            key: widget.key,
            readOnly: widget.isReadOnly,
            maxLines: widget.maxLines,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textInputAction: widget.inputAction,
            enableSuggestions: false,
            keyboardType: widget.keyboardType,
            onSaved: widget.onSaved,
            validator: widget.validator,
            initialValue: widget.initialValue,
            decoration: textFormDecoration(
              label: widget.label,
              prefixIcon: widget.prefixIcon,
            ),
            focusNode: widget.focusNode,
            onTap: widget.onTap,
          ),
        ],
      ),
    );
  }
}

InputDecoration textFormDecoration({
  required IconData prefixIcon,
  required String label,
}) {
  return InputDecoration(
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
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
    focusColor: accentColor,
    prefixIcon: Icon(
      prefixIcon,
      color: contentColorLightTheme,
      size: 20,
    ),
    hintText: label,
    hintStyle: TextStyle(
      color: Colors.grey,
      fontSize: 16,
    ),
  );
}
