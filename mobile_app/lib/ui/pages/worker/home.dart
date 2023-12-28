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

  @override
  void initState() {
    super.initState();
    _bookingRequestsListFuture = _getWorkers();
  }

  // returns the list of verified workers
  Future<List<BookingModel>> _getWorkers() async {
    try {
      return await BookingService.getBookingRequests(context: context);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CstmDrawer(),
      drawerEnableOpenDragGesture: true,
      drawerEdgeDragWidth: 50,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CstmAppBar(
            stretchTrigger: () {
              return Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  _bookingRequestsListFuture = _getWorkers();
                });
              });
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  margin: EdgeInsets.zero,
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
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder<List<BookingModel>>(
                future: _bookingRequestsListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          '${snapshot.error}',
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: const Center(
                        child: Text(
                          'No Handymen Available!',
                          style: TextStyle(fontSize: 18),
                        ),
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
