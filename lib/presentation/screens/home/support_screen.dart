import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/buttons/custom_button.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

enum Types {
  complain,
  suggestion,
}

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  Types? selectedMenu = Types.complain;

  // TextEditingController titleController = TextEditingController();

  GlobalKey<FormState> form = GlobalKey<FormState>();
  final bool _autoValidate = false;

  Widget _textFieldHeader(String text, int duration) {
    return SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: duration,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 4),
          child: Text(
            text,
            style: Get.textTheme.titleSmall?.copyWith(
              fontFamily: "Algerian",
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'support',
          style: Get.textTheme.headlineMedium?.copyWith(
            fontFamily: "Algerian",
          ),
        ).tr(),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.all(8.0),
        child: Form(
          key: form,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: CustomScrollView(
            slivers: [
              _textFieldHeader(tr('title'), 700),
              AppTextField(
                hintText: tr('title'),
                icon: Icons.title,
                controller: titleController,
                duration: 700,
                validator: (value) => authNotifier.validateTitle(value),
              ),
              const SliverSizedBox(height: 12),
              _textFieldHeader(tr('description'), 700),
              AppTextField(
                hintText: tr('description'),
                icon: Icons.description,
                controller: descController,
                duration: 700,
                validator: (value) => authNotifier.validateDesc(value),
              ),
              const SliverSizedBox(height: 12),
              _textFieldHeader(tr('types'), 700),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 400,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kColorCard,
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      value: authNotifier.type,
                      selectedItemBuilder: (context) => List.generate(
                        2,
                        (index) => DropdownMenuItem(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              authNotifier.type == 0
                                  ? tr('complain')
                                  : tr('suggestion'),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ).toList(),
                      dropdownColor: kColorBackground,
                      items: [
                        DropdownMenuItem(
                          value: 0,
                          child: Text(tr('complain')),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text(tr('suggestion')),
                        ),
                      ],
                      onChanged: (value) {
                        authNotifier.setType(value);
                        log(authNotifier.type.toString());
                      },
                    ),
                  ),
                ),
              ),
              const SliverSizedBox(height: 24),
              SliverToBoxAdapter(
                child: HorizontalAnimation(
                  duration: 1000,
                  child: CustomButton(
                    width: context.width / 2.5,
                    text: tr("send"),
                    onTap: () => authNotifier.sendSupport(
                      titleController.text,
                      descController.text,
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
