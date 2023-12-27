import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';

import '../../../../widgets/userinfo_tile.dart';

class UserDetails extends StatefulWidget {
  final UserModel user;
  const UserDetails({super.key, required this.user});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late UserModel _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = widget.user;

    // Simulate loading data with a delay of 1 sec
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Avatar(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    sources: [
                      if (_user.profilePicUrl != null)
                        NetworkSource(_user.profilePicUrl!)
                    ],
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                    shape: AvatarShape.circle(100),
                    name: _user.firstName.toTitleCase(),
                  ),
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                              )
                            ],
                          ),
                          Container(
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
                  ),
                  _user.role == 'worker'
                      ? Card(
                          margin: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UserInfoItem(
                                icon: Icons.work_outline,
                                label: 'Job',
                                value: _user.job!.toTitleCase(),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.circle_outlined,
                                  color: _user.availability == 'available'
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                                title: const Text(
                                  'Status',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                subtitle:
                                    Text(_user.availability!.toTitleCase()),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Card(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 5),
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
                          value: _user.dob!,
                        ),
                        UserInfoItem(
                          icon: Icons.place_outlined,
                          label: 'Address',
                          value: _user.address!,
                        ),
                        UserInfoItem(
                          icon: Icons.male,
                          label: 'Gender',
                          value: _user.gender!.toTitleCase(),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    margin:
                        const EdgeInsets.only(right: 10, left: 10, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            height: 280,
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(_user.citizenshipUrl!),
                                    fit: BoxFit.cover),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          _user.paymentQrUrl != null
                              ? Container(
                                  height: 280,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                              NetworkImage(_user.paymentQrUrl!),
                                          fit: BoxFit.cover),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(10)),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
