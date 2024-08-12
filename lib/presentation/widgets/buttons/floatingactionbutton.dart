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
      child: Column(children: [
        const SizedBox(height: 6),
        const Padding(
          padding: const EdgeInsets.only(top: 8),
          child: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 29,
          ),
        )
      ]),
      //params
    );
  }
}
