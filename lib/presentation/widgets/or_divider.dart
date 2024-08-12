import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/widgets/widgets.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 700,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _divider(),
            const Text(
              'Or',
              style: TextStyle(fontFamily: 'Algerian'),
            ).tr(),
            _divider(),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Expanded(
      child: Container(
        height: 1,
        width: 5,
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
