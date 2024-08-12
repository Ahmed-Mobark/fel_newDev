// ignore_for_file: unused_element

import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/signin/singin_param.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/bottom_nav_notifier.dart';
import 'package:football_app/presentation/notifiers/googleclasssignin.dart';
import 'package:football_app/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/or_divider.dart';
import 'package:football_app/presentation/widgets/password_obscure_text_button.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      final bottomNavigationBarNotifier =
          Provider.of<BottomNavigationBarNotifier>(context, listen: false);
      bottomNavigationBarNotifier.setNavbarIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: HorizontalAnimation(
        duration: 2500,
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.device_unknown,
                color: Theme.of(context).primaryColor,
              ),
              TextButton(
                onPressed: () => authNotifier.visitorLogin(),
                child: Text(
                  'Explore as Guest',
                  style: TextStyle(
                    fontFamily: "Algerian",
                    fontSize: 16,
                    color: kColorPrimary,
                  ),
                ).tr(),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Form(
          key: authNotifier.loginFormKey,
          child: CustomScrollView(
            slivers: [
              const _AppBar(),
              SliverSizedBox(height: 6.h),
              AppTextField(
                controller: authNotifier.loginUsernameController,
                hintText: 'Username',
                icon: Icons.person,
                duration: 800,
                validator: (value) => authNotifier.validateLoginUsername(value),
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                controller: authNotifier.loginPasswordController,
                hintText: 'Password',
                icon: Icons.password,
                duration: 600,
                validator: (value) => authNotifier.validateLoginPassword(value),
                obscureText: authNotifier.isObscure,
                suffixIcon: const PasswordFieldObscureTextButton(),
              ),
              SliverSizedBox(height: 1.h),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 600,
                  child: Row(
                    children: [
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.to(
                            () => const ForgotPasswordScreen(),
                          );
                          // authNotifier.clearLoginControllers();
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(fontFamily: 'Algerian'),
                        ).tr(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverSizedBox(height: 1.h),
              authNotifier.loginLoading
                  ? const AppLoadingIndicator()
                  : SliverToBoxAdapter(
                      child: 
                      HorizontalAnimation(
                        duration: 500,
                        child: FilledButton(
                          onPressed: () {
                            if (authNotifier.loginFormKey.currentState!
                                .validate()) {
                              SigninParam param = SigninParam(
                                username:
                                    authNotifier.loginUsernameController.text,
                                password:
                                    authNotifier.loginPasswordController.text,
                              );
                              authNotifier.signin(param);
                            } else {
                              // ScaffoldMessenger.of(context)
                              //   ..hideCurrentSnackBar()
                              //   ..showSnackBar(
                              //     errorSnackBar(
                              //       tr('Fill fields with correct data'),
                              //     ),
                              //   );
                            }
                          },
                          style: FilledButton.styleFrom(
                            disabledBackgroundColor: Colors.grey.shade600,
                            disabledForegroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Login',
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
              SliverSizedBox(height: 1.h),
              const _RegisterNowButton(),
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
        child: Text(
          'Login',
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
      child: HorizontalAnimation(
        duration: 500,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // _RegisterWithSocialMediaButtons(
            //   onTap: () {
            //     //      authNotifier.facebookAuth(context);
            //     _facebookLogin();
            //   },
            //   icon: FontAwesomeIcons.facebook,
            // ),
            _RegisterWithSocialMediaButtons(
              onTap: () {
                authNotifier.googleAuth(context);
              },
              icon: FontAwesomeIcons.google,
            ),
            if (Platform.isIOS)
              _RegisterWithSocialMediaButtons(
                onTap: () {
                  authNotifier.appleAuth(context);
                },
                icon: FontAwesomeIcons.apple,
              ),
          ],
        ),
      ),
    );
  }

  _facebookLogin() async {
    final fb = FacebookLogin();

    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    switch (res.status) {
      case FacebookLoginStatus.success:
        final FacebookAccessToken? accessToken = res.accessToken;
        final profile = await fb.getUserProfile();
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        final email = await fb.getUserEmail();
        print('Access token:   ${accessToken?.token}');
        print('Hello:   ${profile?.firstName}');
        print('image:   ${imageUrl?.codeUnits}');
        if (email != null) print("your email is $email");
        break;

      case FacebookLoginStatus.cancel:
        // TODO: Handle this case.
        print("cancel");
        break;
      case FacebookLoginStatus.error:
        // TODO: Handle this case.
        print('Eroor is : ${res.error}');
        break;
    }
  }

  Future signIn(BuildContext context) async {
    final user = await GoogleSignInApi.login();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "sign in failed",
            style: TextStyle(
              fontFamily: "Algerian",
            ),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    var tokenid = user!.authentication.then(
      (GoogleSignInAuthentication value) {
        debugPrint("${value.idToken}", wrapWidth: 50);
      },
    );
  }
}

class _RegisterWithSocialMediaButtons extends StatelessWidget {
  const _RegisterWithSocialMediaButtons({
    required this.onTap,
    required this.icon,
  });

  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
    );
  }
}

class _RegisterNowButton extends StatelessWidget {
  const _RegisterNowButton();

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 400,
        child: TextButton(
          onPressed: () {
            Get.offNamed('/register');
            //  authNotifier.clearLoginControllers();
          },
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: tr('Dont have an account?'),
                  style: TextStyle(
                    fontFamily: "Algerian",
                    color: Get.theme.primaryColorLight,
                    fontSize: 11.sp,
                  ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: tr('Register Now!'),
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
