import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../models/store_model/coin_model.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/user_coins.dart';

class PurchaseCard extends StatelessWidget {
  final Coin product;
  final bool isLoading;
  final Function(ProductDetails productDetails) buyItem;
  const PurchaseCard(this.product, this.buyItem,
      {super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: context.width / 2.1,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(
              width: context.width / 2.1,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: Image.network(product.logo).image,
                      fit: BoxFit.cover)),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserCoins(
                    product.coinsAmount.toString(),
                    //           ??  Platform.isIOS
                    // ? product.productDetails?.title.toString() ?? ""
                    //       : product.productDetails?.description.toString() ?? "",
                    isThereAFunction: false,
                    isFromCoinsStore: true,
                  ),
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(product.productDetails?.price.toString() ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Algerian",
                            fontSize: 14)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomButton(
                    width: context.width / 2.3,
                    text: tr("Buy"),
                    onTap: () => buyItem(product.productDetails!),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
