import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/register_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RegisterSecondScreen extends StatelessWidget {
  const RegisterSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerProvider =
        Provider.of<RegisterNotifier>(context, listen: true);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Form(
          key: registerProvider.formKey,
          child: CustomScrollView(
            slivers: [
              const _AppBar(),
              SliverSizedBox(height: 6.h),
              const _ShirtWidget(),
              AppTextField(
                duration: 800,
                controller: registerProvider.shirtNameController,
                hintText: 'Name',
                icon: Ionicons.person,
                keyboardType: TextInputType.text,
                onChanged: (value) => registerProvider.updateShirtName(value),
                validator: (p0) => registerProvider.validateShirtName(p0),
              ),
              SliverSizedBox(height: 2.h),
              AppTextField(
                duration: 700,
                controller: registerProvider.shirtNumberController,
                hintText: 'Number',
                icon: Icons.numbers,
                onChanged: (value) => registerProvider.updateShirtNumber(value),
                validator: (p0) => registerProvider.validateShirtNumber(p0),
                keyboardType: TextInputType.number,
              ),
              SliverSizedBox(height: 4.h),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 600,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      disabledBackgroundColor: Colors.grey.shade600,
                      disabledForegroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (registerProvider.formKey.currentState!.validate()) {
                        if (context.read<AuthNotifier>().isSocialLogged) {
                          Get.offAndToNamed('/welcome');
                        } else {
                          Get.offAndToNamed('/login');
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            errorSnackBar(
                              'Fill fields with correct data',
                            ),
                          );
                      }
                    },
                    child: const Text(
                      'Finish',
                      style: TextStyle(fontFamily: 'Algerian'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShirtWidget extends StatelessWidget {
  const _ShirtWidget();

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterNotifier>(
      context,
      listen: true,
    );
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 900,
        child: UserShirt(
          name: registerProvider.shirtNameController.text,
          number: registerProvider.shirtNumberController.text,
          gradient: RadialGradient(
            colors: [
              kColorAccent.withOpacity(0.3),
              kColorPrimary.withOpacity(0.2),
              // Colors.yellow.withOpacity(0.3),
              // Colors.greenAccent.withOpacity(0.3),
              kColorPrimaryDark.withOpacity(0.3),
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
          'Last Steps...',
          style: Get.textTheme.displayLarge?.copyWith(
            fontFamily: "Algerian",
          ),
        ),
      ),
    );
  }
}
