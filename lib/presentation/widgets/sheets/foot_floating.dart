import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';

class FootFloatingButton extends StatelessWidget {
  const FootFloatingButton({
    super.key,
    required this.ontap,
    required this.text,
  });
  final VoidCallback ontap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: ontap,
          child: Container(
            height: 50,
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: kColorPrimary,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            margin: const EdgeInsetsDirectional.only(
              start: 20,
              end: 20,
              bottom: 20,
            ),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(fontFamily: 'Algerian'),
            )),
          ),
        ),
      ),
    );
  }
}
