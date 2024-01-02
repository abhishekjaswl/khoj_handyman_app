import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/user_model.dart';
import '../../../../core/services/booking_service.dart';
import '../../../widgets/cstm_button.dart';

class BookingRequestInput extends StatefulWidget {
  final UserModel user;
  const BookingRequestInput({super.key, required this.user});

  @override
  State<BookingRequestInput> createState() => _BookingRequestInputState();
}

class _BookingRequestInputState extends State<BookingRequestInput> {
  final _bookingFormKey = GlobalKey<FormState>();

  final TextEditingController _dtController = TextEditingController();
  DateTime? selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Form(
              key: _bookingFormKey,
              child: TextFormField(
                controller: _dtController,
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.calendar_today),
                  labelText: "Booking Date and Time",
                  labelStyle: const TextStyle(fontSize: 15),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
                readOnly: true,
                onTap: () async {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2025),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          DateTime dateTime = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          print(dateTime);

                          setState(() {
                            selectedDateTime = dateTime;
                            _dtController.text =
                                DateFormat('yyyy-MM-dd | hh:mm a ')
                                    .format(dateTime);
                          });
                        }
                      });
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date and time of booking';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Message (optional)',
                    labelStyle: const TextStyle(fontSize: 15),
                    filled: true,
                    focusColor: Theme.of(context).colorScheme.tertiary,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding: const EdgeInsets.all(13),
                    prefixIcon: const Icon(Icons.abc)),
              ),
            ),
            CstmButton(
              btnColor: Colors.green,
              leadingIcon: const Icon(Icons.tour_outlined),
              text: 'Book Now',
              onPressed: () {
                if (_bookingFormKey.currentState!.validate()) {
                  BookingService.requestBooking(
                    context: context,
                    workerId: widget.user.id,
                    dateTime: selectedDateTime!,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
