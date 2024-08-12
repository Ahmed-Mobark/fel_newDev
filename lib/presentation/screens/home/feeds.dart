part of '../screens.dart';

class FeedsPage extends StatefulWidget {
  const FeedsPage({Key? key}) : super(key: key);

  @override
  FeedsPageState createState() => FeedsPageState();
}

class FeedsPageState extends State<FeedsPage> {
  HomeNotifier? _homeNotifier;
  AuthNotifier? _authNotifier;
  final refresh.RefreshController _refreshController =
      refresh.RefreshController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() {
    _homeNotifier = Provider.of<HomeNotifier>(context, listen: false);
    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    _homeNotifier?.getHomePageData();
    _homeNotifier?.getAdminChallenges();
    _authNotifier?.getUserData();
  }

  onRefresh() async {
    await getData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarNotifier =
        Provider.of<BottomNavigationBarNotifier>(context, listen: true);
    final homeNotifier = Provider.of<HomeNotifier>(context, listen: true);

    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: onRefresh,
        child: CustomScrollView(
          slivers: [
            const FeedCarousel(),
            SliverSizedBox(
              height: 2.h,
            ),
            if (homeNotifier.mainPageModel.isSponsorActive ?? false) ...[
              const SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 800,
                  child: TextTileFeed(
                    label: 'Sponsors',
                    icon: FontAwesomeIcons.superpowers,
                  ),
                ),
              ),
              SliverSizedBox(
                height: 2.h,
              ),
              const SliverToBoxAdapter(
                child: SponsorsRail(),
              ),
              SliverSizedBox(
                height: 2.h,
              ),
            ],
            SliverToBoxAdapter(
              child: HorizontalAnimation(
                duration: 800,
                child: TextTileFeed(
                  label: 'Groups',
                  icon: Icons.groups,
                  onTap: () {
                    navigationBarNotifier.setNavbarIndex(2);
                  },
                ),
              ),
            ),
            SliverSizedBox(
              height: 2.h,
            ),
            const SliverToBoxAdapter(
              child: GroupsRail(),
            ),
            SliverSizedBox(
              height: 2.h,
            ),
            const SliverToBoxAdapter(
              child: HorizontalAnimation(
                duration: 700,
                child: TextTileFeed(
                  label: 'Top 10',
                  icon: Ionicons.analytics,
                ),
              ),
            ),
            SliverSizedBox(
              height: 1.5.h,
            ),
            const SliverToBoxAdapter(
              child: TopTenChallengers(),
            ),
            SliverSizedBox(
              height: 3.h,
            ),
            const SliverToBoxAdapter(
              child: HorizontalAnimation(
                duration: 700,
                child: TextTileFeed(
                  label: 'Admin Challenges2',
                  icon: Icons.local_fire_department,
                ),
              ),
            ),
            SliverSizedBox(
              height: 3.h,
            ),
            SliverToBoxAdapter(
              child: AdminMatches(onUpdate: getData),
            ),
            SliverSizedBox(
              height: 3.h,
            ),
            if ((homeNotifier.mainPageModel.isQuestionActive ?? false) &&
                homeNotifier.mainPageModel.question?.question != null) ...[
              const SliverToBoxAdapter(
                child: Visibility(
                  visible: true,
                  // visible: homeNotifier.mainPageModel.question != null &&
                  //     homeNotifier.mainPageModel.hasAnsweredQuestion != true,
                  child: HorizontalAnimation(
                    duration: 700,
                    child: TextTileFeed(
                      label: 'Bonus Question',
                      icon: FontAwesomeIcons.b,
                    ),
                  ),
                ),
              ),
              SliverSizedBox(
                height: 1.h,
              ),
              const CounterWidget(),
              const QuestionWidget(),
            ],
            SliverSizedBox(
              height: 18.h,
            ),
          ],
        ),
      ),
    );
  }
}
