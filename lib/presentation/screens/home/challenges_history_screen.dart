import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChallengesHistoryScreen extends StatelessWidget {
  const ChallengesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Challenges',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      body: Center(
        child: const Text(
          'Waiting for api.',
          style: TextStyle(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
    );
  }
}
