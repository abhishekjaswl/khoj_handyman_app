import 'package:flutter/material.dart';
import 'package:mobile_app/ui/widgets/cstm_button.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/booking_service.dart';

class Payment extends StatelessWidget {
  final String bookingId;
  const Payment({
    super.key,
    required this.bookingId,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 5),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 280,
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                Provider.of<CurrentUser>(context, listen: false)
                                    .user
                                    .paymentQrUrl!),
                            fit: BoxFit.cover),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  CstmButton(
                      text: 'Done',
                      onPressed: () => {
                            BookingService.updateCurrentBooking(
                              context: context,
                              id: bookingId,
                              action: 'complete',
                            )
                          })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
