import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CstmDatePicker extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onDateSelected;

  const CstmDatePicker({
    super.key,
    this.controller,
    this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: const Icon(Icons.calendar_today),
        labelText: "Date of Birth",
        labelStyle: const TextStyle(fontSize: 15),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
      readOnly: true,
      //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime(2002),
            firstDate: DateTime(1980),
            //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2015));

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          onDateSelected!(formattedDate);
        } else {}
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Date of birth';
        }
        return null;
      },
    );
  }
}
