import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/signup_model/verify_email_param.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _counter = 60;
  Timer? _timer;

  _setTimer() {
    _timer?.cancel();
    _counter = 60;
    if (mounted) setState(() {});

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_counter > 0) _counter--;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setTimer();
    if (context.read<AuthNotifier>().isLogin) {
      sendCode();
    }
  }

  sendCode() {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    final id = authNotifier.userModel.data?.id ?? authNotifier.userId ?? '';
    authNotifier.resendCode(id);
    _counter = 60;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              centerTitle: true,
              pinned: true,
              leading: null,
              title: FadeIn(
                child: Text(
                  'verify_email',
                  style: Get.textTheme.displayLarge?.copyWith(
                    fontFamily: "Algerian",
                  ),
                ).tr(),
              ),
            ),
            SliverSizedBox(height: 6.h),
            AppTextField(
              controller: authNotifier.verificationCodeController,
              hintText: kVerificationCode,
              icon: Icons.verified_user_outlined,
              duration: 800,
            ),
            SliverSizedBox(height: 4.h),
            SliverToBoxAdapter(
              child: HorizontalAnimation(
                duration: 500,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _counter == 0 ? sendCode : null,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _counter == 0
                              ? Theme.of(context).primaryColor.withOpacity(0.5)
                              : Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: _counter == 0
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).colorScheme.background,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _counter.toString(),
                                style: (_counter == 0
                                        ? Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                        : Theme.of(context).textTheme.bodyLarge)
                                    ?.copyWith(
                                        fontFamily: "Algerian",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              tr('resend_otp'),
                              style: (_counter == 0
                                      ? Theme.of(context).textTheme.displaySmall
                                      : Theme.of(context).textTheme.bodyLarge)
                                  ?.copyWith(
                                      fontFamily: "Algerian",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverSizedBox(height: 6.h),
            !authNotifier.verificationCodeLoading
                ? SliverToBoxAdapter(
                    child: HorizontalAnimation(
                      duration: 500,
                      child: FilledButton(
                        onPressed: () {
                          VerifyEmailParam param = VerifyEmailParam(
                            userId: authNotifier.userId ??
                                authNotifier.userModel.data?.id ??
                                authNotifier.userId ??
                                '',
                            code: authNotifier.verificationCodeController.text,
                          );

                          authNotifier.verifyEmailCheck(param);
                        },
                        style: FilledButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade600,
                          disabledForegroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(fontFamily: 'Algerian'),
                        ).tr(),
                      ),
                    ),
                  )
                : const AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
