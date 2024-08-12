import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../models/forgetpassword/forgetpass_param.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Form(
          key: authNotifier.forgetpassFormKey,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                centerTitle: true,
                pinned: true,
                title: FadeIn(
                  child: Text(
                    'Forgot Password',
                    style: Get.textTheme.displayLarge?.copyWith(
                      fontFamily: "Algerian",
                    ),
                  ).tr(),
                ),
              ),
              SliverSizedBox(height: 6.h),
              AppTextField(
                controller: authNotifier.emailforgetpassController,
                hintText: 'Email',
                icon: Icons.email,
                validator: (value) => authNotifier.validateLoginUsername(value),
                duration: 800,
              ),
              SliverSizedBox(height: 2.h),
              !authNotifier.loginLoading
                  ? SliverToBoxAdapter(
                      child: HorizontalAnimation(
                        duration: 500,
                        child: FilledButton(
                          onPressed: () {
                            // print(authNotifier.forgetpassFormKey.currentState!
                            //     .validate());
                            if (authNotifier.forgetpassFormKey.currentState!
                                .validate()) {
                              Forgetpassparam param = Forgetpassparam(
                                  email: authNotifier
                                      .emailforgetpassController.text);
                              authNotifier.forgetpass(param);
                            } else {
                              // print("12");
                              // Forgetpassparam param = Forgetpassparam(
                              //     email: authNotifier
                              //         .loginUsernameController.text);
                              // authNotifier.forgetpass(param);
                            }
                            //     print("notddddvalid");

                            //   Get.to(() => const ResetPasswordScreen());
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
                  : const AppLoadingIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
