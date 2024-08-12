part of '../screens.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

  Timer? _debounce;

  StoreNotifier? storeProvider;

  _onSearchChanged(String query, storeProvider) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      storeProvider.searchFilterChange(query);
    });
  }

  final GlobalKey _coins = GlobalKey();
  final GlobalKey _myItems = GlobalKey();

  _startShowCase() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      if (!(prefs.getBool('show_store_case') ?? false)) {
        ShowCaseWidget.of(context).startShowCase([_coins, _myItems]);
        prefs.setBool('show_store_case', true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    _getToken();
    // final storeProvider = Provider.of<StoreNotifier>(context, listen: false);
    storeProvider?.itemsFilter.skip = 0;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      storeProvider?.getStoreItems(storeProvider!.itemsFilter);
    });
    storeProvider?.storeController
        .addListener(storeProvider!.updateStoreItemsData);
    // });
    _startShowCase();
  }

  String? token;

  _getToken() async {
    token = await rxPrefs.getString('token');
    setState(() {});
    if (token != null) {
      storeProvider?.getPurchasedItemsIds();
      storeProvider?.getCoins();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _debounce?.cancel();
    storeProvider?.storeController
        .removeListener(storeProvider!.updateStoreItemsData);
  }

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreNotifier>(context, listen: true);
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            controller: storeProvider.storeController,
            slivers: [
              ///AppBar
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: FadeIn(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    kStore,
                    style: Get.textTheme.headlineMedium?.copyWith(
                      fontFamily: "Algerian",
                    ),
                  ),
                ),
                centerTitle: true,
                pinned: true,
                leadingWidth: 100,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Showcase(
                    key: _coins,
                    title: tr('coins'),
                    description: tr('coins_desc'),
                    targetBorderRadius: BorderRadius.circular(10000),
                    titleTextStyle: const TextStyle(
                        fontFamily: 'Algerian', color: Colors.black,),
                    descTextStyle: TextStyle(
                        fontFamily: 'Algerian',
                        color: Colors.black,
                        fontSize: 8.sp,),
                    descriptionPadding: const EdgeInsets.symmetric(vertical: 8),
                    child: UserCoins(
                      authNotifier.userModel.data?.coinsBalance.toString() ??
                          "",
                    ),
                  ),
                ),
                actions: [
                  if (token != null)
                    FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: Showcase(
                        key: _myItems,
                        title: tr('my_items'),
                        description: tr('my_items_desc'),
                        targetBorderRadius: BorderRadius.circular(10000),
                        titleTextStyle: const TextStyle(
                            fontFamily: 'Algerian', color: Colors.black,),
                        descTextStyle: TextStyle(
                            fontFamily: 'Algerian',
                            color: Colors.black,
                            fontSize: 8.sp,),
                        descriptionPadding:
                            const EdgeInsets.symmetric(vertical: 8),
                        child: IconButton(
                          onPressed: () => Get.toNamed('/PurchasedProducts'),
                          icon: const Icon(
                            size: 30,
                            Ionicons.bag_handle,
                          color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
                expandedHeight: 180,
                flexibleSpace: FlexibleSpaceBar(
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: [
                        SizedBox(height: Platform.isAndroid ? 90 : 120),
                        SizedBox(
                          height: 60,
                          width: context.width - 20,
                          child: CustomScrollView(
                            slivers: [
                              AppTextField(
                                controller: storeProvider.textEditingController,
                                hintText: tr('Search'),
                                icon: Icons.search,
                                duration: 800,
                                onChanged: (v) =>
                                    _onSearchChanged(v, storeProvider),
                              ),
                              //
                            ],
                          ),
                        ),
                        const StoreCatergoriesTabs(
                          isStore: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (storeProvider.products.firstOrNull?.category == 1)
                StoreTShirtList(storeProvider.products),
              if (storeProvider.products.firstOrNull?.category == 2)
                StoreTProfileList(storeProvider.products),
              if (storeProvider.products.firstOrNull?.category == 3)
                StoreTGroupList(storeProvider.products),
              SliverSizedBox(
                height: 11.h,
              ),
            ],
          ),
        ),
        if (storeProvider.leagueLoading)
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
    );
  }
}
