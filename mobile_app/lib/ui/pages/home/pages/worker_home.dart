import 'package:flutter/material.dart';
import 'package:mobile_app/utils/extensions/string_ext.dart';
import 'package:provider/provider.dart';

import '../../../../core/providers/currentuser_provider.dart';
import '../../../widgets/cstm_appbar.dart';
import '../../../widgets/cstm_drawer.dart';

class WorkerHome extends StatefulWidget {
  const WorkerHome({super.key});

  @override
  State<WorkerHome> createState() => _WorkerHomeState();
}

class _WorkerHomeState extends State<WorkerHome> {
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
                setState(() {});
              });
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    margin: const EdgeInsets.all(8),
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
                            'What are we up to today?',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
