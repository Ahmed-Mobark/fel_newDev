part of 'widgets.dart';

class InputSearchProduct extends StatelessWidget {
  const InputSearchProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Row(
        children: [
          Expanded(
            child: HorizontalAnimation(
              duration: 500,
              child: Container(
                height: 5.h,
                margin: const EdgeInsetsDirectional.only(start: 10),
                decoration: BoxDecoration(
                  color: kColorCard,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search products',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsetsDirectional.only(top: 9),
                      hintStyle: Get.textTheme.titleMedium!.copyWith(
                        fontFamily: "Algerian",
                        color: kColorIconHomeHint,
                      ),
                      prefixIcon: Icon(
                        Ionicons.search,
                        color: kColorIconHomeHint,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          HorizontalAnimation(
            duration: 600,
            child: IconButton(
              onPressed: () {
                Get.bottomSheet(
                  const FilterSearch(),
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                );
              },
              icon: Icon(
                FontAwesomeIcons.sliders,
                color: Colors.white,
                size: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardItemShop extends StatelessWidget {
  const CardItemShop({
    super.key,
    required this.storeModel,
    required this.width,
    this.isCover = false,
    this.isTShirt = false,
  });

  final StoreModel storeModel;
  final bool isCover;
  final bool isTShirt;
  final width;

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

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
          Container(
            width: double.maxFinite,
            height: 26.h,
            padding:
                isTShirt ? const EdgeInsets.only(top: 10) : EdgeInsets.zero,
            decoration: BoxDecoration(
              color:
                  isCover ? Colors.transparent : Colors.grey.withOpacity(0.6),
              gradient: isCover
                  ? null
                  : RadialGradient(
                      colors: [
                        storeModel.bgColor == null
                            ? kColorPrimary.withOpacity(0.2)
                            : hexToColor(storeModel.bgColor ?? "#FFFFFF"),
                        storeModel.bgColor == null
                            ? kColorPrimary.withOpacity(0.2)
                            : hexToColor(storeModel.bgColor ?? "#FFFFFF"),
                        Colors.white,
                      ],
                    ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      context.locale.languageCode == "en"
                          ? storeModel.name
                          : context.locale.languageCode == 'ar'
                              ? storeModel.arName
                              : context.locale.languageCode == 'es'
                                  ? storeModel.esName
                                  : storeModel.poName,
                      // maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Algerian',
                        fontSize: 9.sp,
                        color: Colors.white,
                        wordSpacing: 1,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  UserCoins(
                    storeModel.price.toString(),
                    isThereAFunction: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: width - 20,
            text: storeProvider.purschasedIds[storeModel.id] == null
                ? tr("Buy")
                : tr("Purchased"),
            // onTap: () => storeProvider.buyTheItem(
            //     storeModel.id, authNotifier.changeNumberOfCoins)),
            onTap: storeProvider.purschasedIds[storeModel.id] == null
                ? () => purchaseAlertDialog(
                      context,
                      isTShirt: isTShirt,
                      () => storeProvider.buyTheItem(
                        storeModel.id,
                        authNotifier.changeNumberOfCoins,
                      ),
                      storeModel,
                      isGroup: storeModel.category == 3,
                    )
                : null,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CardGroupPictureScreen extends StatelessWidget {
  const CardGroupPictureScreen({
    super.key,
    required this.storeModel,
    required this.groupId,
    required this.width,
    required this.itemIndex,
  });

  final StoreModel storeModel;
  final int itemIndex;
  final String groupId;
  final width;

  @override
  Widget build(BuildContext context) {
    GroupNotifier groupNotifier =
        Provider.of<GroupNotifier>(context, listen: true);
    StoreNotifier storeProvider =
        Provider.of<StoreNotifier>(context, listen: true);
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: width,
            height: 25.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: Image.network(storeModel.photo).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: width - 20,
            text: tr("Set"),
            // onTap: () => storeProvider.buyTheItem(
            //     storeModel.id, authNotifier.changeNumberOfCoins)),
            onTap: storeProvider.purchashedLoading
                ? null
                : () async {
                    List didSucceed = await storeProvider.setGroupImage(
                      storeModel.id,
                      groupId,
                    );
                    if (didSucceed[0]) {
                      await groupNotifier.setGroupPicture(
                        itemIndex,
                        didSucceed[1],
                      );
                      Get.back();
                    }
                  },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CardItemProfileShop extends StatelessWidget {
  const CardItemProfileShop({
    super.key,
    required this.storeModel,
    required this.width,
  });

  final StoreModel storeModel;
  final double width;

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
          Container(
            width: width,
            height: 25.h,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: Image.network(storeModel.photo).image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      context.locale.languageCode == "en"
                          ? storeModel.name
                          : context.locale.languageCode == 'ar'
                              ? storeModel.arName
                              : context.locale.languageCode == 'es'
                                  ? storeModel.esName
                                  : storeModel.poName,
                      // maxLines: 1,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: Colors.white,
                        fontFamily: "Algerian",
                        wordSpacing: 1,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  UserCoins(
                    storeModel.price.toString(),
                    isThereAFunction: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          CustomButton(
            width: width - 20,
            text: storeProvider.purschasedIds[storeModel.id] == null
                ? tr("Buy")
                : tr("Purchased"),
            // onTap: () => purchaseAlertDialog(context)),
            onTap: storeProvider.purschasedIds[storeModel.id] == null
                ? () => purchaseAlertDialog(
                      context,
                      () => storeProvider.buyTheItem(
                        storeModel.id,
                        authNotifier.changeNumberOfCoins,
                      ),
                      storeModel,
                      isProfile: true,
                    )
                : null,
          ),
          const SizedBox(height: 10),
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

class SimilarProducts extends StatelessWidget {
  const SimilarProducts({
    super.key,
    required this.storeModel,
  });

  final StoreModel storeModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(
        () => StoreContent(storeModel: storeModel),
        preventDuplicates: false,
      ),
      child: Container(
        width: 100.w,
        height: 10.h,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
        margin: const EdgeInsetsDirectional.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                width: 10.h,
                height: 10.h,
                imageUrl: storeModel.photo,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      storeModel.name,
                      style: Get.textTheme.headlineMedium?.copyWith(
                        fontFamily: "Algerian",
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      storeModel.price.toString(),
                      style: Get.textTheme.titleSmall!.copyWith(
                        fontFamily: "Algerian",
                        color: kColorIconHomeHint,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.ellipsisVertical,
                size: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCatergoriesTabs extends StatelessWidget {
  const StoreCatergoriesTabs({required this.isStore, super.key});
  final bool isStore;
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
              isSelected: i ==
                  (isStore
                      ? storeNotifier.itemsFilter.category - 1
                      : storeNotifier.itemsPurchasedFilter.category - 1),
              label: tr(kStoreCategories[i]),
              onTap: () {
                storeNotifier.setCategoryIndex(i, isStore);
              },
            ),
          );
        },
      ),
    );
  }
}
