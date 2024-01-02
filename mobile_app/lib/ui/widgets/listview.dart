import 'package:flutter/material.dart';
import 'package:mobile_app/core/models/user_model.dart';
import 'package:mobile_app/ui/pages/profile/user_details.dart';
import 'package:mobile_app/ui/pages/user/widgets/cstm_card.dart';

class CstmList extends StatefulWidget {
  final Future<List<UserModel>> listFuture;
  const CstmList({super.key, required this.listFuture});

  @override
  State<CstmList> createState() => _CstmListState();
}

class _CstmListState extends State<CstmList> {
  String _searchQuery = '';

  List<UserModel> _filterUsers(List<UserModel> userList, String searchQuery) {
    return userList
        .where((user) => (user.firstName + user.lastName + user.email)
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: FutureBuilder<List<UserModel>>(
        future: widget.listFuture,
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
                'Wow! So Empty.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final userList = _filterUsers(snapshot.data!, _searchQuery);
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Search',
                      labelStyle: const TextStyle(fontSize: 15),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      focusColor: Theme.of(context).colorScheme.tertiary,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      contentPadding: const EdgeInsets.all(5),
                    ),
                  ),
                ),
                _filterUsers(snapshot.data!, _searchQuery).isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text(
                            'No results!',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userList.length,
                          itemBuilder: (BuildContext context, int index) {
                            UserModel user = userList[index];
                            return CstmCard(
                              user: user,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserDetails(
                                            user: user,
                                            title: 'User Details',
                                          ))),
                            );
                          },
                        ),
                      ),
              ],
            );
          }
        },
      ),
    );
  }
}