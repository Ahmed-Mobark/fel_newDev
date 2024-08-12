import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/user_coins.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CoinPurchaseAppbar extends StatelessWidget {
  const CoinPurchaseAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return Container(
      padding: const EdgeInsets.all(5),
      width: context.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MaterialButton(
            minWidth: 15,
            padding: const EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: () => Navigator.of(context).pop(),
            splashColor: Colors.transparent,
            child: const SizedBox(
                height: 40,
                width: 45,
                child: Icon(Icons.arrow_back_sharp,
                    color: Colors.white, size: 25)),
          ),
          Center(
              child: Text(
            tr("CoinStore"),
            style: Get.textTheme.headlineMedium?.copyWith(
              fontFamily: "Algerian",
            ),
          )),
          Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(5),
            ),
            child: UserCoins(
              authNotifier.userModel.data?.coinsBalance.toString() ?? "0",
              isThereAFunction: false,
            ),
          ),
        ],
      ),
    );
  }
}
