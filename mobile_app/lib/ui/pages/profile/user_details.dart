import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/core/services/user_service.dart';
import 'package:mobile_app/ui/pages/profile/view_documents.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/currentuser_provider.dart';
import '../../../core/services/booking_service.dart';
import '../../widgets/cstm_button.dart';
import '../../widgets/cstm_msgborder.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;
  final String title;
  const UserDetails({
    super.key,
    required this.user,
    required this.title,
  });

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late UserModel _user;
  late String _title;
  late String? _availability;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _title = widget.title;
    _availability = widget.user.availability;
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
              _user.status == 'unverified' && _title == 'Profile'
                  ? Transform.translate(
                      offset: const Offset(0, -5),
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: MessageBorder(),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: const Text(
                                'You are not verified. Please fill up the KYC to be verified.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            FilledButton(
                              child: const Text('KYC Form'),
                              onPressed: () =>
                                  {Navigator.pushNamed(context, '/kyc')},
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              _user.role == 'worker'
                  ? Card(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfoItem(
                            icon: Icons.work_outline,
                            label: 'Job',
                            value: (_user.job ?? 'N/a').toTitleCase(),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.circle_outlined,
                              color: _availability == 'available'
                                  ? Colors.greenAccent
                                  : Colors.redAccent,
                            ),
                            title: const Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text(_availability!.toTitleCase()),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            onTap: Provider.of<CurrentUser>(context,
                                            listen: false)
                                        .user
                                        .id ==
                                    _user.id
                                ? () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 200,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.greenAccent,
                                                ),
                                                title: const Text(
                                                  'Available',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                subtitle: const Text(
                                                    'You will receive booking requests.'),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                onTap: () => {
                                                  UserService
                                                      .updateUserAvailability(
                                                    context: context,
                                                    id: _user.id,
                                                    availability: 'available',
                                                  ),
                                                  setState(() {
                                                    _availability = 'available';
                                                    context
                                                        .read<CurrentUser>()
                                                        .setAvailability(
                                                            'available');
                                                  })
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(
                                                  Icons.circle_outlined,
                                                  color: Colors.redAccent,
                                                ),
                                                title: const Text(
                                                  'Unavailable',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                subtitle: const Text(
                                                    'You will NOT receive booking requests.'),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                onTap: () => {
                                                  UserService
                                                      .updateUserAvailability(
                                                    context: context,
                                                    id: _user.id,
                                                    availability: 'unavailable',
                                                  ),
                                                  setState(() {
                                                    _availability =
                                                        'unavailable';
                                                    context
                                                        .read<CurrentUser>()
                                                        .setAvailability(
                                                            'unavailable');
                                                  })
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    )
                  : Container(),
              Card(
                margin: const EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoItem(
                      icon: Icons.person_4_outlined,
                      label: 'Role',
                      value: _user.role.toTitleCase(),
                    ),
                    UserInfoItem(
                      icon: Icons.phone_iphone,
                      label: 'Phone Number',
                      value: _user.phone.toString(),
                    ),
                    UserInfoItem(
                        icon: Icons.calendar_month_outlined,
                        label: 'Date of Birth',
                        value: _user.dob == null
                            ? 'N/a'
                            : DateFormat('yyyy-MM-dd').format(_user.dob!)),
                    UserInfoItem(
                      icon: Icons.place_outlined,
                      label: 'Address',
                      value: _user.address ?? 'N/a',
                    ),
                    UserInfoItem(
                      icon: Icons.male,
                      label: 'Gender',
                      value: (_user.gender ?? 'N/a').toTitleCase(),
                    ),
                  ],
                ),
              ),
              _title != 'Booking'
                  ? Card(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UserInfoItem(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewDocuments(
                                        user: _user, title: _title))),
                            icon: Icons.description_outlined,
                            label: 'Documents',
                            value: (_user.citizenshipUrl != null
                                    ? 'Citizenship'
                                    : 'N/a') +
                                (_user.paymentQrUrl != null
                                    ? ' | PaymentQr'
                                    : _user.role == 'worker'
                                        ? 'N/a'
                                        : ''),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              _title == 'Booking'
                  ? Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.calendar_today),
                                labelText: "Booking Date and Time",
                                labelStyle: const TextStyle(fontSize: 15),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary)),
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
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                ).then((selectedDate) {
                                  if (selectedDate != null) {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      if (selectedTime != null) {
                                        DateTime selectedDateTime = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );
                                        String formattedDateTime = DateFormat(
                                                "yyyy-MM-ddTHH:mm:ss.SSSZ")
                                            .format(selectedDateTime);
                                        print(formattedDateTime);
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: CstmButton(
                                btnColor: Colors.green,
                                leadingIcon: const Icon(Icons.tour_outlined),
                                text: 'Book Now',
                                onPressed: () {
                                  BookingService.updateBookingRequests(
                                    context: context,
                                    id: _user.id,
                                    action: 'book',
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
