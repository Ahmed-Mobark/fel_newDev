import 'package:flutter/material.dart';

import '../../../helpers/helpers.dart';

class FloatingActionbotton extends StatelessWidget {
  final VoidCallback floatingactionfunction;
  const FloatingActionbotton({required this.floatingactionfunction, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kColorPrimary,
      onPressed: () {
        // navigationBarNotifier.setNavbarIndex(2);
        floatingactionfunction();
      },
      child: const Column(children: [
        SizedBox(height: 6),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 29,
          ),
        )
      ]),
      //params
    );
  }
}
