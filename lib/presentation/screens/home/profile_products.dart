part of '../screens.dart';

class PurchasedProducts extends StatefulWidget {
  const PurchasedProducts({super.key});

  @override
  State<PurchasedProducts> createState() => _PurchasedProductsState();
}

class _PurchasedProductsState extends State<PurchasedProducts> {
  StoreNotifier? storeProvider;

  @override
  void initState() {
    super.initState();
    storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    storeProvider?.itemsPurchasedFilter.skip = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storeProvider?.getCoins();
      storeProvider?.getPurchasedItems(storeProvider!.itemsPurchasedFilter);
    });
    storeProvider?.purchaseController
        .addListener(storeProvider!.updatePurchasedItemsData);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    storeProvider?.purchaseController
        .removeListener(storeProvider!.updatePurchasedItemsData);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreNotifier>(context, listen: true);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomScrollView(
              controller: storeProvider.purchaseController,
              slivers: [
                ///AppBar
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  leading: InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  title: FadeIn(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      kPurchasedProducts,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                  centerTitle: true,
                  pinned: true,
                  // leadingWidth: 100,
                  // leading: Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: UserCoins(
                  //     authNotifier.userModel.data?.coinsBalance.toString() ??
                  //         "",
                  //   ),
                  // ),
                  actions: [
                    FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Ionicons.bag_handle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  expandedHeight: 130,
                  flexibleSpace: const FlexibleSpaceBar(
                    background: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(height: 100),
                          // SizedBox(
                          //   height: 60,
                          //   width: context.width - 20,
                          //   child: CustomScrollView(
                          //     slivers: [
                          //       AppTextField(
                          //         controller: storeProvider.textEditingController,
                          //         hintText: 'Search',
                          //         icon: Icons.search,
                          //         duration: 800,
                          //         onChanged: storeProvider.searchFilterChange,
                          //       ),
                          //       //
                          //     ],
                          //   ),
                          // ),
                          StoreCatergoriesTabs(isStore: false),
                        ],
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //   child: SizedBox(
                //     height: 0,
                //   ),
                // ),

                if (storeProvider.purchasedItems.isEmpty) ...{
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        tr('no_data'),
                        style: Get.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Algerian",
                        ),
                      ),
                    ),
                  ),
                } else ...{
                  if (storeProvider.purchasedItems.firstOrNull?.category == 1)
                    ProfileProductsTShirtList(storeProvider.purchasedItems),
                  if (storeProvider.purchasedItems.firstOrNull?.category == 2)
                    ProfileProductsProfileList(storeProvider.purchasedItems),
                  if (storeProvider.purchasedItems.firstOrNull?.category == 3)
                    ProfileProductsGroupList(storeProvider.purchasedItems),
                },
                SliverSizedBox(
                  height: 11.h,
                ),
              ],
            ),
          ),
          if (storeProvider.purchashedLoading)
            const Padding(
              padding: EdgeInsets.only(top: 200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
