part of '../screens.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeNotifier homeNotifier =
        Provider.of<HomeNotifier>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Challenges',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 10,
        ),
        itemCount: homeNotifier.adminChallengesModel.length,
        padding: const EdgeInsetsDirectional.all(8),
        itemBuilder: (context, index) {
          final challenge = homeNotifier.adminChallengesModel[index];
          return AdminChallengesCard(
            challengeModel: challenge,
          );
        },
      ),
    );
  }
}
