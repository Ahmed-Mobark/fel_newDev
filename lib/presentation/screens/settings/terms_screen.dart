import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:football_app/presentation/notifiers/app_settings_notifier.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AppSettingsNotifier>().getAppTerms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppSettingsNotifier appSettingsNotifier =
        Provider.of<AppSettingsNotifier>(context, listen: true);

    return Scaffold(
      body: Column(
        children: [
          const _AppBar(),
          SizedBox(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              child: appSettingsNotifier.termsLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: HtmlWidget(
                        appSettingsNotifier.terms ?? '',
                      ),
                    ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: FadeIn(
        duration: const Duration(milliseconds: 500),
        child: Text(
          'Terms Of Use',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
