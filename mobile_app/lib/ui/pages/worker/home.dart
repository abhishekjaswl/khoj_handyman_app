import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/ui/pages/worker/widgets/booking_details.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/booking_service.dart';
import '../../widgets/cstm_appbar.dart';
import '../../widgets/cstm_drawer.dart';
import 'widgets/booking_card.dart';

class WorkerHomePage extends StatefulWidget {
  const WorkerHomePage({super.key});

  @override
  State<WorkerHomePage> createState() => _WorkerHomePageState();
}

class _WorkerHomePageState extends State<WorkerHomePage> {
  late Future<List<BookingModel>> _bookingRequestsListFuture;
  late Future<List<BookingModel>> _currentBookingsListFuture;

  @override
  void initState() {
    super.initState();
    _bookingRequestsListFuture = _getBookingRequests();
    _currentBookingsListFuture = _getCurrentBookings();
  }

  Future<void> _refreshData() async {
    setState(() {
      _bookingRequestsListFuture = _getBookingRequests();
      _currentBookingsListFuture = _getCurrentBookings();
    });
  }

  Future<List<BookingModel>> _getBookingRequests() async {
    try {
      return await BookingService.getBookingRequests(context: context);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BookingModel>> _getCurrentBookings() async {
    try {
      return await BookingService.getCurrentBookings(context: context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(80), child: CstmAppBar()),
      drawer: const CstmDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 50,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back, ${'${Provider.of<CurrentUser>(context).user.firstName} ${Provider.of<CurrentUser>(context).user.lastName}'.toTitleCase()}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Text(
                            'Ready to get work done?',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Current Bookings',
                  style: TextStyle(fontSize: 20),
                ),
                FutureBuilder<List<BookingModel>>(
                  future: _currentBookingsListFuture,
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
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    } else {
                      final currentBookings = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentBookings.length,
                        itemBuilder: (BuildContext context, int index) {
                          BookingModel currentBooking = currentBookings[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BookingDetails(
                                          booking: currentBooking,
                                          title: 'Current Booking',
                                        ))),
                            child: BookingCard(
                              booking: currentBooking,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Booking Requests',
                  style: TextStyle(fontSize: 20),
                ),
                FutureBuilder<List<BookingModel>>(
                  future: _bookingRequestsListFuture,
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
                          style: TextStyle(fontSize: 14),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
