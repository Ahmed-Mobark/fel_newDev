part of '../screens.dart';

class UserGroupImages extends StatefulWidget {
  final String groupId;
  final int groupIndex;
  const UserGroupImages(
      {required this.groupId, super.key, required this.groupIndex});

  @override
  State<UserGroupImages> createState() => _UserGroupImagesState();
}

class _UserGroupImagesState extends State<UserGroupImages> {
  StoreNotifier? storeProvider;

  @override
  void initState() {
    super.initState();
    storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    storeProvider?.getCoins();
    storeProvider?.groupPicturesPurchasedFilter.skip = 0;
    storeProvider
        ?.getPurchasedGroupPicture(storeProvider!.groupPicturesPurchasedFilter);
    storeProvider?.purchasedGroupPictureController
        .addListener(storeProvider!.updatePurchasedItemsData);
  }

  @override
  void dispose() {
    super.dispose();
    // final storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    storeProvider?.purchaseController
        .removeListener(storeProvider!.updatePurchasedItemsData);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreNotifier>(context, listen: true);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    final BottomNavigationBarNotifier navigationBarNotifier =
        Provider.of<BottomNavigationBarNotifier>(context, listen: true);
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
                  automaticallyImplyLeading: false,
                  title: FadeIn(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      tr("Change Group Picture"),
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                  centerTitle: true,
                  pinned: true,
                  leadingWidth: 100,
                  actions: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: UserCoins(
                        authNotifier.userModel.data?.coinsBalance.toString() ??
                            "",
                      ),
                    ),
                  ],
                  leading: InkWell(
                    onTap: () => Get.back(),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  expandedHeight: 50,
                ),

                GroupPictureList(
                    storeProvider.purchasedGroupPicture, widget.groupId,
                    groupIndex: widget.groupIndex),

                SliverSizedBox(
                  height: 5.h,
                ),
                if (storeProvider.purchasedGroupPicture.isEmpty &&
                    !storeProvider.purchashedLoading)
                  SliverSizedBox(
                    child: CustomButton(
                        width: context.width - 60,
                        text: tr("Go to group covers store"),
                        // onTap: () => storeProvider.buyTheItem(
                        //     storeModel.id, authNotifier.changeNumberOfCoins)),
                        onTap: () {
                          storeProvider.itemsFilter.category = 3;
                          navigationBarNotifier.setNavbarIndex(3);
                          Get.back();
                          Get.back();
                        }),
                  ),
                SliverSizedBox(
                  height: 5.h,
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
            )
        ],
      ),
    );
  }
}
