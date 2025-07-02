import 'package:flutter/material.dart';

class BillInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String)? onChanged;

  const BillInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Enter Bill Amount',
        hintText: '0.00',
        prefixIcon: const Icon(Icons.attach_money),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        errorText: _validateInput(controller.text),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }

  String? _validateInput(String value) {
    if (value.isNotEmpty) {
      final parsed = double.tryParse(value);
      if (parsed == null) {
        return 'Please enter a valid number';
      }
      if (parsed < 0) {
        return 'Value cannot be negative';
      }
    }
    return null;
  }
}
