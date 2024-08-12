import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              title: FadeIn(
                child: Text(
                  'Reset Password',
                  style: Get.textTheme.displayLarge?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
