import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/booking_service.dart';
import 'package:mobile_app/ui/pages/worker/payment.dart';
import 'package:mobile_app/ui/pages/worker/widgets/location.dart';
import 'package:mobile_app/ui/pages/worker/widgets/map.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/currentuser_provider.dart';
import '../../../widgets/cstm_button.dart';

class BookingDetails extends StatefulWidget {
  final BookingModel booking;
  final String title;
  const BookingDetails({
    super.key,
    required this.booking,
    required this.title,
  });

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  late BookingModel _booking;
  late UserModel _user;
  late String _title;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
    _user = widget.booking.user;
    _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_user.firstName.toTitleCase()} ${_user.lastName.toTitleCase()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _user.email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: _user.status == 'verified'
                                    ? Theme.of(context).colorScheme.tertiary
                                    : Theme.of(context).colorScheme.secondary,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              _user.status.toTitleCase(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    ),
                    Avatar(
                      sources: [
                        if (_user.profilePicUrl != null)
                          NetworkSource(_user.profilePicUrl!)
                      ],
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      shape: AvatarShape.circle(80),
                      name: _user.firstName.toTitleCase(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CstmMap(
                      latitude: _user.latitude!,
                      longitude: _user.longitude!,
                      myLocation: false),
                ),
              ),
              Card(
                margin: const EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoItem(
                      icon: Icons.badge_outlined,
                      label: 'Booking Id',
                      value: _booking.id,
                    ),
                    UserInfoItem(
                      icon: Icons.phone_iphone,
                      label: 'Phone Number',
                      value: _user.phone.toString(),
                    ),
                    UserInfoItem(
                      icon: Icons.calendar_month_outlined,
                      label: 'Date & Time',
                      value: DateFormat('yyyy-MM-dd | hh:mm a')
                          .format(_booking.dateTime),
                    ),
                    UserInfoItem(
                      icon: Icons.place_outlined,
                      label: 'Address',
                      value: _user.address ?? 'N/a',
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserLocation(
                                  latitude: _user.latitude!,
                                  longitude: _user.longitude!))),
                    ),
                  ],
                ),
              ),
              _title != 'Booking History'
                  ? Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                  labelText: 'Message',
                                  labelStyle: const TextStyle(fontSize: 15),
                                  filled: true,
                                  focusColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  contentPadding: const EdgeInsets.all(13),
                                  prefixIcon: const Icon(Icons.abc)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Provider.of<CurrentUser>(context)
                                          .user
                                          .role ==
                                      'worker'
                                  ? _title == 'Booking'
                                      ? Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: CstmButton(
                                                btnColor: Colors.green,
                                                leadingIcon:
                                                    const Icon(Icons.check),
                                                text: 'Accept',
                                                onPressed: () {
                                                  BookingService
                                                      .updateBookingRequests(
                                                    context: context,
                                                    id: _booking.id,
                                                    action: 'accept',
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: CstmButton(
                                                btnColor: Colors.red,
                                                leadingIcon:
                                                    const Icon(Icons.close),
                                                text: 'Decline',
                                                onPressed: () {
                                                  BookingService
                                                      .updateBookingRequests(
                                                    context: context,
                                                    id: _booking.id,
                                                    action: 'decline',
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: CstmButton(
                                                btnColor: Colors.green,
                                                leadingIcon:
                                                    const Icon(Icons.check),
                                                text: 'Complete',
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Payment(
                                                        bookingId: _booking.id,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.3,
                                              child: CstmButton(
                                                btnColor: Colors.red,
                                                leadingIcon:
                                                    const Icon(Icons.close),
                                                text: 'Cancel',
                                                onPressed: () {
                                                  BookingService
                                                      .updateCurrentBooking(
                                                    context: context,
                                                    id: _booking.id,
                                                    action: 'cancel',
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        )
                                  : CstmButton(
                                      btnColor: Colors.red,
                                      leadingIcon: const Icon(Icons.close),
                                      text: 'Cancel',
                                      onPressed: () {
                                        BookingService.updateBookingRequests(
                                          context: context,
                                          id: _booking.id,
                                          action: 'cancel',
                                        );
                                      },
                                    ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Function()? onTap;

  const UserInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.tertiary,
      ),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(value),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      onTap: onTap,
    );
  }
}
