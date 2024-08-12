import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/notifiers/transactions_notifier.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  TransactionsNotifier? _transactionsNotifier;

  @override
  void initState() {
    super.initState();
    _transactionsNotifier =
        Provider.of<TransactionsNotifier>(context, listen: false);
    _transactionsNotifier?.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    _transactionsNotifier =
        Provider.of<TransactionsNotifier>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          // controller: storeProvider.purchaseController,
          slivers: [
            ///AppBar
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: FadeIn(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Transactions',
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ).tr(),
              ),
              centerTitle: true,
              pinned: true,
              leading: BackButton(
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
              expandedHeight: 80,
              flexibleSpace: const FlexibleSpaceBar(
                background: Align(
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _transactionsNotifier?.myTransactions?.count == 0
                  ? Center(
                      child: Text(
                        tr('no_data'),
                        style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Algerian",
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount:
                          _transactionsNotifier?.myTransactions?.count ?? 0,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding:
                          const EdgeInsetsDirectional.symmetric(horizontal: 10),
                      itemBuilder: (context, int i) {
                        final transaction = _transactionsNotifier
                            ?.myTransactions?.transactions![i];
                        return HorizontalAnimation(
                          duration: 700,
                          child: FadeIn(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: kColorCard,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          // Text(
                                          //   '${tr('Coin Purchased')}: ',
                                          //   style: Get.textTheme.displaySmall,
                                          // ),
                                          SvgPicture.asset(
                                            'assets/images/coins.svg',
                                            // ignore: deprecated_member_use
                                            allowDrawingOutsideViewBox: true,
                                            height: 3.h,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            ': ${transaction?.coinPurchased} -> ${transaction?.purchaseAmount} \$',
                                            style: Get.textTheme.displaySmall
                                                ?.copyWith(
                                              fontFamily: "Algerian",
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          // Text(
                                          //   '${tr('Amount')}: ',
                                          //   style: Get.textTheme.displaySmall,
                                          // ),
                                          Text(
                                            DateFormat('dd-MM-yyyy', 'en')
                                                .format(
                                              DateTime.parse(
                                                transaction?.purchasedAt ??
                                                    DateTime.now().toString(),
                                              ),
                                            ),
                                            style: Get.textTheme.displaySmall
                                                ?.copyWith(
                                              fontFamily: "Algerian",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: kColorPrimary,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      tr(
                                        transaction?.status?.toLowerCase() ??
                                            '',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: "Algerian",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 12,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
