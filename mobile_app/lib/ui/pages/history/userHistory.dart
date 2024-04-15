import 'package:flutter/material.dart';

import '../../../core/models/user_model.dart';
import '../../../core/services/booking_service.dart';
import '../worker/widgets/booking_card.dart';
import '../worker/widgets/booking_details.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  late Future<List<BookingModel>> _myBookingHistoryListFuture;

  @override
  void initState() {
    super.initState();
    _myBookingHistoryListFuture = _getMyBookingHistory();
  }

  Future<List<BookingModel>> _getMyBookingHistory() async {
    try {
      return await BookingService.getMyBookingHistory(context: context);
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
            title: const Text('Booking History'),
            onStretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() => _getMyBookingHistory());
              });
            },
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<BookingModel>>(
                future: _myBookingHistoryListFuture,
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
                                        title: 'Booking History',
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
