import 'package:flutter/material.dart';
import 'package:mobile_app/core/services/booking_service.dart';

import '../../../core/models/user_model.dart';
import '../worker/widgets/booking_card.dart';
import '../worker/widgets/booking_details.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  late Future<List<BookingModel>> _myBookingRequestsListFuture;

  @override
  void initState() {
    super.initState();
    _myBookingRequestsListFuture = _getMyBookings();
  }

  Future<List<BookingModel>> _getMyBookings() async {
    try {
      return await BookingService.getMyBookings(context: context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('My Bookings'),
            onStretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() => _getMyBookings());
              });
            },
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<BookingModel>>(
                future: _myBookingRequestsListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error}',
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Oh no! You have no booking requests.',
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  } else {
                    final bookingRequests = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bookingRequests.length,
                      itemBuilder: (BuildContext context, int index) {
                        BookingModel bookingRequest = bookingRequests[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingDetails(
                                        booking: bookingRequest,
                                        title: 'Booking',
                                      ))),
                          child: BookingCard(
                            booking: bookingRequest,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
