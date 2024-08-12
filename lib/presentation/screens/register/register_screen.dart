import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/signup_model/signup_param.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/or_divider.dart';
import 'package:football_app/presentation/widgets/password_obscure_text_button.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
          key: authNotifier.signupFormKey,
          child: CustomScrollView(
            slivers: [
              const _AppBar(),
              SliverSizedBox(height: 6.h),
              AppTextField(
                duration: 1200,
                controller: authNotifier.nameController,
                hintText: 'Username',
                icon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('This field cannot be empty');
                  }
                  if (value.length <= 8) {
                    return 'The username must be at least 8 letters';
                  }
                  return null;
                },
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 1100,
                controller: authNotifier.emailController,
                hintText: 'Email',
                icon: Icons.email,
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('This field cannot be empty');
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 1000,
                controller: authNotifier.passwordController,
                hintText: 'Password',
                icon: Icons.password_rounded,
                obscureText: authNotifier.isObscure,
                suffixIcon: const PasswordFieldObscureTextButton(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('This field cannot be empty');
                  }
                  if (value.length <= 8) {
                    return tr('Please enter a valid password');
                  }
                  return null;
                },
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 900,
                controller: authNotifier.confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.password_rounded,
                obscureText: authNotifier.isObscure,
                suffixIcon: const PasswordFieldObscureTextButton(),
                validator: (value) {
                  if (value!.isEmpty) {
                    return tr('This field cannot be empty');
                  }
                  if (value != authNotifier.passwordController.text) {
                    return tr('Passwords do not match');
                  }
                  return null;
                },
              ),
              SliverSizedBox(height: 4.h),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 800,
                  child: authNotifier.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : FilledButton(
                          onPressed: () {
                            if (authNotifier.signupFormKey.currentState!
                                .validate()) {
                              SignupParam param = SignupParam(
                                username: authNotifier.nameController.text,
                                email: authNotifier.emailController.text,
                                confirmPassword:
                                    authNotifier.confirmPasswordController.text,
                                password: authNotifier.passwordController.text,
                              );
                              authNotifier.signup(param);
                            } else {
                              // ScaffoldMessenger.of(context)
                              //   ..hideCurrentSnackBar()
                              //   ..showSnackBar(
                              //     errorSnackBar(
                              //       'Fill fields with correct data',
                              //     ),
                              //   );
                            }
                          },
                          style: FilledButton.styleFrom(
                            disabledBackgroundColor: Colors.grey.shade600,
                            disabledForegroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(fontFamily: 'Algerian'),
                          ).tr(),
                        ),
                ),
              ),
              SliverSizedBox(height: 2.h),
              const OrDivider(),
              SliverSizedBox(height: 4.h),
              const _OtherAuthButtonsRow(),
              SliverSizedBox(height: 2.h),
              const _LoginNowButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      centerTitle: true,
      pinned: true,
      title: FadeIn(
        duration: const Duration(milliseconds: 600),
        child: Text(
          'Register',
          style: Get.textTheme.displayLarge?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
      ),
    );
  }
}

class _OtherAuthButtonsRow extends StatelessWidget {
  const _OtherAuthButtonsRow();

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);

    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // _LoginWithSocialMediaButtons(
          //   onTap: () {
          //     authNotifier.facebookAuth(context);
          //   },
          //   icon: FontAwesomeIcons.facebook,
          // ),
          _LoginWithSocialMediaButtons(
            onTap: () {
              authNotifier.googleAuth(context);
            },
            icon: FontAwesomeIcons.google,
          ),
          if (Platform.isIOS)
            _LoginWithSocialMediaButtons(
              onTap: () {
                authNotifier.appleAuth(context);
              },
              icon: FontAwesomeIcons.apple,
            ),
        ],
      ),
    );
  }
}

class _LoginWithSocialMediaButtons extends StatelessWidget {
  const _LoginWithSocialMediaButtons({
    required this.onTap,
    required this.icon,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HorizontalAnimation(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsetsDirectional.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: kColorIconCardHint,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
          ),
          child: Icon(
            icon,
            color: kDefaultIconLightColor,
          ),
        ),
      ),
    );
  }
}

class _LoginNowButton extends StatelessWidget {
  const _LoginNowButton();

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context);
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 1000,
        child: TextButton(
          onPressed: () {
            Get.offNamed('/login');
            //  authNotifier.clearSignupControllers();
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: "${tr('Already have an account?')}\n",
                  style: TextStyle(
                    fontFamily: "Algerian",
                    color: Get.theme.primaryColorLight,
                    fontSize: 11.sp,
                  ),
                ),
                TextSpan(
                  text: tr('Login'),
                  style: TextStyle(
                    fontFamily: "Algerian",
                    color: Get.theme.primaryColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
