import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool obscure;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;

  const CustomField({
    super.key,
    required this.label,
    required this.icon,
    this.obscure = false,
    required this.onSaved,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}