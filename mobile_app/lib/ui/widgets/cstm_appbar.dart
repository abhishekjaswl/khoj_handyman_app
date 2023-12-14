import 'package:flutter/material.dart';

class CstmAppBar extends StatefulWidget {
  final Future<void> Function()? stretchTrigger;
  const CstmAppBar({
    super.key,
    this.stretchTrigger,
  });

  @override
  State<CstmAppBar> createState() => _CstmAppBarState();
}

class _CstmAppBarState extends State<CstmAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Builder(
          builder: (BuildContext context) {
            return IconButton(
              splashRadius: 20,
              icon: const Icon(
                Icons.menu_sharp,
                size: 30,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      onStretchTrigger: widget.stretchTrigger,
      collapsedHeight: 80,
      floating: true,
      pinned: true,
      titleSpacing: 0,
      elevation: 0,
      toolbarHeight: 80,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'khoj',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
