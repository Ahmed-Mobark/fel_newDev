part of '../screens.dart';

class StoreContent extends StatelessWidget {
  const StoreContent({Key? key, required this.storeModel}) : super(key: key);

  final StoreModel storeModel;

  @override
  Widget build(BuildContext context) {
    final sizePadTop = MediaQuery.of(context).padding.top;
    return Scaffold(
      bottomNavigationBar: const CardBottomBuy(),
      body: CustomScrollView(
        slivers: [
          ///List Images
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 50.h,
            primary: true,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                color: Colors.white,
                width: 100.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView(onPageChanged: (int value) {}, children: [
                      CachedNetworkImage(
                        imageUrl: storeModel.photo,
                        // placeholder: (_, i) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // },
                      )
                    ]

                        // storeModel.images.map((e) {
                        //   return CachedNetworkImage(
                        //     imageUrl: e,
                        //     placeholder: (_, i) {
                        //       return const Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     },
                        //   );
                        // }).toList(),
                        ),
                    //Dotes
                    Positioned(
                      bottom: 10,
                      child: Row(
                        children: [
                          for (int i = 0; i < 3; i++)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              // width:
                              //     i == state.indexImageProduct ? 8.w : 3.w,
                              height: 5,
                              margin: const EdgeInsetsDirectional.symmetric(
                                horizontal: 2.5,
                              ),
                              decoration: BoxDecoration(
                                // color: i == state.indexImageProduct
                                //     ? kColorPrimary
                                //     : kColorCard,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          top: sizePadTop + 10,
                          start: 10,
                          end: 10,
                        ),
                        child: FadeIn(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              maxRadius: 16.sp,
                              backgroundColor: Colors.black12.withOpacity(.1),
                              child: CircleAvatar(
                                maxRadius: 15.sp,
                                backgroundColor: Colors.white.withOpacity(.3),
                                child: Icon(
                                  FontAwesomeIcons.chevronLeft,
                                  color: Colors.white,
                                  size: 15.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  width: 10.w,
                  height: 5,
                  margin: const EdgeInsetsDirectional.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: kColorIconHomeHint,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ///Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: HorizontalAnimation(
                        duration: 400,
                        child: Text(
                          storeModel.name,
                          style: Get.textTheme.displaySmall?.copyWith(
                            fontFamily: "Algerian",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    HorizontalAnimation(
                      duration: 450,
                      child: Text(
                        '${storeModel.price}',
                        style: Get.textTheme.displaySmall!.copyWith(
                          fontFamily: "Algerian",
                          color: kColorPrimary,
                        ),
                      ),
                    ),
                  ],
                ),

                ///Time & Date
                HorizontalAnimation(
                  duration: 500,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(vertical: 5),
                    child: Text(
                      storeModel.category.toString(),
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                ),

                ///Size
                Padding(
                  padding: const EdgeInsetsDirectional.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      HorizontalAnimation(
                        duration: 550,
                        child: Text(
                          'Size',
                          style: Get.textTheme.titleMedium?.copyWith(
                            fontFamily: "Algerian",
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      for (int i = 0; i < kSizes.length; i++)
                        HorizontalAnimation(
                          duration: 300 * (i + 2),
                          child: CardSize(
                            label: kSizes[i],
                            isSelected: false,
                            onTap: () {},
                          ),
                        ),
                    ],
                  ),
                ),

                ///Content
                HorizontalAnimation(
                  duration: 600,
                  child: HtmlWidget(
                    kContent,
                  ),
                ),
              ]),
            ),
          ),

          ///Tile Trending News
          SliverToBoxAdapter(
            child: HorizontalAnimation(
              duration: 650,
              child: TextTileFeed(
                label: kSimilarItems,
              ),
            ),
          ),

          /// List News
          SliverPadding(
            padding: const EdgeInsetsDirectional.only(top: 0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  return HorizontalAnimation(
                    duration: 400 + (i + 3),
                    child: SimilarProducts(
                      storeModel: StoreApi.products[i],
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ),
          //SizeBox Height
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
