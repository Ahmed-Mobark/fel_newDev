import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../helpers/helpers.dart';
import '../../models/store_model/store_model.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/store_notifier.dart';
import 'buttons/custom_button.dart';
import 'dialogs/purchase_dialog.dart';
import 'w_feeds.dart';
import 'widgets.dart';

class CardProductProfileShop extends StatelessWidget {
  const CardProductProfileShop({
    super.key,
    required this.storeModel,
    this.isTShirt = false,
    required this.width,
    this.buttonText = "",
  });

  final StoreModel storeModel;
  final double width;
  final bool isTShirt;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    StoreNotifier storeProvider =
        Provider.of<StoreNotifier>(context, listen: true);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ///oooomer
          Container(
            width: width,
            height: 26.h,
            padding:
                isTShirt ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              // image: DecorationImage(
              //     image: Image.network(storeModel.photo).image,
              //     fit: isTShirt ? BoxFit.scaleDown : BoxFit.cover)),
            ),
            child: CachedNetworkImage(
              imageUrl: storeModel.photo,
              fit: isTShirt ? BoxFit.scaleDown : BoxFit.cover,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: isTShirt ? BoxFit.scaleDown : BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.question_mark,
                size: 10.h,
              ),
            ),
          ),

          if (storeModel.category != 3)
            Column(
              children: [
                const SizedBox(height: 10),
                CustomButton(
                  width: width - 20,
                  text: buttonText,
                  fontSize: 13,
                  // onTap: () => storeProvider.buyTheItem(
                  //     storeModel.id, authNotifier.changeNumberOfCoins)),
                  onTap: () => purchaseAlertDialog(
                    context,
                    () => storeProvider.setItem(
                      storeModel.id,
                      storeModel.category == 1,
                    ),
                    storeModel,
                    isTShirt: isTShirt,
                    isGroup: storeModel.category == 3,
                    isStore: false,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
        ],
      ),
    );
  }
}

class CardSize extends StatelessWidget {
  const CardSize({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 10.w,
      height: 10.w,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: isSelected ? null : Border.all(color: kColorCardHint),
        color: isSelected ? kColorPrimary : null,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Center(
          child: Text(
            label,
            style: Get.textTheme.titleSmall?.copyWith(
              fontFamily: "Algerian",
            ),
          ),
        ),
      ),
    );
  }
}

class CardBottomBuy extends StatelessWidget {
  const CardBottomBuy({super.key});

  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      child: Container(
        width: 100.w,
        height: 7.h,
        margin: const EdgeInsetsDirectional.all(10),
        decoration: BoxDecoration(
          color: kColorPrimary,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Add to cart',
            style: Get.textTheme.labelLarge?.copyWith(
              fontFamily: "Algerian",
            ),
          ).tr(),
        ),
      ),
    );
  }
}

class StoreCatergoriesTabs extends StatelessWidget {
  const StoreCatergoriesTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreNotifier storeNotifier =
        Provider.of<StoreNotifier>(context, listen: true);

    return SizedBox(
      width: 100.w,
      height: 4.h,
      child: ListView.builder(
        itemCount: kStoreCategories.length,
        shrinkWrap: false,
        physics: const ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, int i) {
          return HorizontalAnimation(
            duration: ((i + 2) * 200),
            child: ChipBarCaty(
              isSelected:
                  i == (storeNotifier.itemsPurchasedFilter.category - 1),
              label: tr(kStoreCategories[i]),
              onTap: () {
                storeNotifier.setCategoryIndex(i, false);
              },
            ),
          );
        },
      ),
    );
  }
}
