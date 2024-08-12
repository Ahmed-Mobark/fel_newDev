import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../notifiers/store_notifier.dart';
import '../../widgets/widgets.dart';
import 'Widgets/coin_purchase_appbar.dart';
import 'Widgets/purchase_card.dart';

class CoinPurchase extends StatefulWidget {
  const CoinPurchase({super.key});

  @override
  State<CoinPurchase> createState() => _CoinPurchaseState();
}

class _CoinPurchaseState extends State<CoinPurchase> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  InAppPurchase inAppPurchase = InAppPurchase.instance;
  bool _isLoading = false;

  List<ProductDetails> _products = [];
  @override
  void initState() {
    super.initState();
    _subscription = inAppPurchase.purchaseStream.listen(purchaseStreamListener);
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  purchaseStreamListener(List<PurchaseDetails> purchaseDetails) async {
    final storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    for (var purchaseDetail in purchaseDetails) {
      if (purchaseDetail.status == PurchaseStatus.pending) {
        print('heloooooo');
        try {
          await InAppPurchase.instance.completePurchase(purchaseDetail);
        } catch (e, s) {
          // Handle errors here
          print('Error completing purchase: $e');
          print('Error completing purchase: $s');
        }
      } else if (purchaseDetail.status == PurchaseStatus.purchased) {
        await storeProvider.coinsPurchased(purchaseDetail, context);
      }
    }
    // Move the setState out of the loop to update the state only once after processing all purchase details
    _isLoading = false;
    setState(() {});
  }

  buyItem(ProductDetails productDetails) async {
    _isLoading = true;
    setState(() {});
    try {
      await inAppPurchase.buyConsumable(
          purchaseParam: PurchaseParam(productDetails: productDetails));
    } catch (e, s) {
      print('asdasdasd $e');
      print(s);
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreNotifier>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              const CoinPurchaseAppbar(),
              const SizedBox(height: 60),
              SizedBox(
                height: context.height - 100,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        width: 100.w,
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 10,
                        ),
                        child: storeProvider.coinsList.isEmpty ||
                                storeProvider.coinsList.first.productDetails ==
                                    null
                            ? Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 50),
                                  child: Text(
                                    tr('no_coins_offers'),
                                    style:
                                        Get.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Algerian",
                                    ),
                                  ),
                                ),
                              )
                            : StaggeredGrid.count(
                                crossAxisCount: 4,
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                                children: [
                                  for (int i = 0;
                                      i < storeProvider.coinsList.length;
                                      i++)
                                    if (storeProvider
                                            .coinsList[i].productDetails !=
                                        null)
                                      StaggeredGridTile.fit(
                                        crossAxisCellCount: 2,
                                        child: HorizontalAnimation(
                                          duration: 200 * (i + 4),
                                          child: PurchaseCard(
                                              storeProvider.coinsList[i],
                                              buyItem,
                                              isLoading: _isLoading),
                                        ),
                                      ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
