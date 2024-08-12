import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/groups_notifer.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class JoinGroupScreen extends StatelessWidget {
  const JoinGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final groupNotifier = Provider.of<GroupNotifier>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.all(8),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: InkWell(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              pinned: true,
              title: FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  tr('Join Group'),
                  style: Get.textTheme.headlineMedium?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ),
              ),
            ),
            const SliverSizedBox(
              height: 30,
            ),
            SliverToBoxAdapter(
              child: HorizontalAnimation(
                duration: 1050,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(bottom: 4),
                  child: Text(
                    tr('To join a private group'),
                    style: Get.textTheme.titleSmall?.copyWith(
                      fontFamily: "Algerian",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AppTextField(
              duration: 1000,
              hintText: tr('Group Code'),
              icon: Icons.qr_code,
              controller: groupNotifier.groupCodeController,
            ),
            const SliverSizedBox(
              height: 24,
            ),
            groupNotifier.joinPrivateGroupLoading
                ? const AppLoadingIndicator()
                : SliverSizedBox(
                    child: HorizontalAnimation(
                      duration: 900,
                      child: FilledButton(
                        onPressed: () {
                          groupNotifier.joinPrivateGroup(
                            groupNotifier.groupCodeController.text,
                          );
                        },
                        child: Text(
                          tr('Join'),
                          style: const TextStyle(fontFamily: "Algerian"),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
