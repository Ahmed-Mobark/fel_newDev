import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/models/store_model/store_model.dart';
import 'package:football_app/presentation/widgets/dialogs/login_popup.dart';
import 'package:provider/provider.dart';

import '../../../helpers/helpers.dart';
import '../../notifiers/auth_notifier.dart';
import '../buttons/custom_button.dart';
import '../user_coins.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

purchaseAlertDialog(
  BuildContext parsedContext,
  Function() onTap,
  StoreModel storeModel, {
  isProfile = false,
  isGroup = false,
  isStore = true,
  isTShirt = false,
}) {
  final AuthNotifier authNotifier =
      Provider.of<AuthNotifier>(parsedContext, listen: false);
  showDialog(
    context: parsedContext,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.grey.shade800.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ), //this right here
        child: SizedBox(
          height: 350,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: kColorPrimary,
                      iconSize: 30,
                    ),
                    UserCoins(
                      authNotifier.userModel.data!.coinsBalance.toString(),
                    ),
                  ],
                ),
                Container(
                  width: isGroup
                      ? 300
                      : isProfile
                          ? 180
                          : 150,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    // color: Colors.white,
                    gradient: isTShirt
                        ? RadialGradient(
                            colors: [
                              storeModel.bgColor == null
                                  ? kColorPrimary.withOpacity(0.2)
                                  : hexToColor(
                                      storeModel.bgColor ?? "#FFFFFF",
                                    ),
                              storeModel.bgColor == null
                                  ? kColorPrimary.withOpacity(0.2)
                                  : hexToColor(
                                      storeModel.bgColor ?? "#FFFFFF",
                                    ),
                              Colors.white,
                            ],
                          )
                        : null,
                    borderRadius: isProfile
                        ? BorderRadius.circular(200)
                        : BorderRadius.circular(15),
                    image: DecorationImage(
                      image: Image.network(storeModel.photo).image,
                      fit: isTShirt ? BoxFit.scaleDown : BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (isStore)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      UserCoins(storeModel.price.toString()),
                    ],
                  ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      onTap: () => Navigator.pop(context),
                      width: 100,
                      text: tr("Cancel"),
                      color: Colors.grey,
                    ),
                    CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                        if (authNotifier.userModel.data?.isGuest ?? false) {
                          showDialog(
                            context: context,
                            builder: (context) => const LoginPopUp(),
                          );
                        } else {
                          onTap();
                        }
                      },
                      width: 100,
                      text: isStore ? tr("Buy") : tr("Set"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

leaveGroupDialog(BuildContext parsedContext, Function() onTap) {
  final AuthNotifier authNotifier =
      Provider.of<AuthNotifier>(parsedContext, listen: false);
  showDialog(
    context: parsedContext,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.grey.shade800.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ), //this right here
        child: SizedBox(
          height: 200,
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      color: kColorPrimary,
                      iconSize: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    tr("doYouWantToLeaveGroup"),
                    style: const TextStyle(fontFamily: 'Algerian'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      onTap: () => Navigator.pop(context),
                      width: 100,
                      text: tr("Cancel"),
                      color: Colors.grey,
                    ),
                    CustomButton(
                      onTap: () {
                        Navigator.pop(context);
                        onTap();
                      },
                      width: 100,
                      text: tr("confirm"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
