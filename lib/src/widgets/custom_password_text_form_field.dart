import 'package:flutter/material.dart' hide FormFieldValidator;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pers/src/constants.dart';

class CustomPasswordTextFormField extends StatefulWidget {
  final IconData prefixIcon;
  final FormFieldValidator validator;
  final String label;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;

  CustomPasswordTextFormField({
    Key? key,
    required this.prefixIcon,
    required this.validator,
    required this.label,
    required this.onSaved,
    required this.onChanged,
  }) : super(key: key);

  @override
  CustomPasswordTextFormFieldState createState() =>
      CustomPasswordTextFormFieldState();
}

class CustomPasswordTextFormFieldState
    extends State<CustomPasswordTextFormField> {
  String pass = "";
  bool _obscure = true;
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            enableSuggestions: false,
            keyboardType: TextInputType.visiblePassword,
            onSaved: widget.onSaved,
            validator: widget.validator,
            obscureText: _obscure,
            onChanged: widget.onChanged,
            decoration: textFormDecoration(
              label: widget.label,
              prefixIcon: widget.prefixIcon,
            ),
          ),
        ],
      ),
    );
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
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      filled: true,
      focusColor: accentColor,
      prefixIcon: Icon(
        prefixIcon,
        color: contentColorLightTheme,
        size: 20,
      ),
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            _obscure = !_obscure;
          });
        },
        icon: Icon(
          _obscure ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: chromeColor,
        ),
      ),
      hintText: label,
      hintStyle: TextStyle(
        color: Colors.grey,
        fontSize: 16,
      ),
    );
  }
}
