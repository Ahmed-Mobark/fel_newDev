import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/helpers/helpers.dart';
import 'package:football_app/models/signin/country_model.dart';
import 'package:football_app/models/update_profile/update_profile_param.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/notifiers/store_notifier.dart';
import 'package:football_app/presentation/widgets/app_text_field.dart';
import 'package:football_app/presentation/widgets/sliver_sized_box.dart';
import 'package:football_app/presentation/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class EditProfileSettingsScreen extends StatefulWidget {
  const EditProfileSettingsScreen({
    super.key,
    this.isFromAuth = false,
    this.isFromAppleAuth = false,
  });

  final bool isFromAuth;
  final bool isFromAppleAuth;

  @override
  State<EditProfileSettingsScreen> createState() =>
      _EditProfileSettingsScreenState();
}

class _EditProfileSettingsScreenState extends State<EditProfileSettingsScreen> {
  bool _autoValidate = false;
  DateTime? _date;
  DateTime _selectedDate = DateTime.now();
  CountryModel? selectedCountry;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _getData();
    // });
  }

  Future<void> _getData() async {
    final AuthNotifier authNotifier = Provider.of<AuthNotifier>(
      context,
      listen: false,
    );

    if (authNotifier.userModel.data?.countryId != null && !widget.isFromAuth) {
      selectedCountry = widget.isFromAuth
          ? null
          : authNotifier.countries.firstWhere(
              (country) => country.id == authNotifier.userModel.data?.countryId,
            );
    }
    authNotifier.firstNameController = TextEditingController(
      text: widget.isFromAuth ? '' : authNotifier.userModel.data?.firstName,
    );
    authNotifier.lastNameController = TextEditingController(
      text: widget.isFromAuth ? '' : authNotifier.userModel.data?.lastName,
    );
    authNotifier.usernameController = TextEditingController(
      text: widget.isFromAuth ? '' : authNotifier.userModel.data?.userName,
    );
    authNotifier.shirtNumberController = TextEditingController(
      text: widget.isFromAuth
          ? ''
          : authNotifier.userModel.data?.shirtNumber.toString(),
    );

    authNotifier.shirtNameController = TextEditingController(
      text: widget.isFromAuth ? '' : authNotifier.userModel.data?.shirtName,
    );
    authNotifier.gender =
        widget.isFromAuth ? 0 : authNotifier.userModel.data?.gender ?? 0;

    authNotifier.birthDateController = TextEditingController(
      text: widget.isFromAuth
          ? ''
          : DateFormat('yyyy-MM-dd', 'en').format(
              DateTime.parse(
                authNotifier.userModel.data?.birthDate ??
                    DateTime.now().toString(),
              ),
            ),
      // : authNotifier.userModel.data?.birthDate?.split('T')[0],
    );
    setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
      locale: context.locale,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: kColorPrimary,
              onPrimary: Colors.white,
              // surface: kColorPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
        _selectedDate = picked;

        authNotifier.birthDateController.text =
            DateFormat('yyyy-MM-dd', 'en').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: true);
    final storeNotifier = Provider.of<StoreNotifier>(context, listen: true);
    Map<String, int> genderMap = {
      tr('Please choose a gender'): 0,
      tr('Male'): 1,
      tr('Female'): 2,
    };
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: FadeIn(
          duration: const Duration(milliseconds: 500),
          child: Text(
            widget.isFromAuth ? 'Last Steps' : 'Profile Settings',
            style: Get.textTheme.headlineMedium?.copyWith(
              fontFamily: "Algerian",
            ),
          ).tr(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF010101),
              kColorPrimaryDark.withOpacity(0.3),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.all(8.0),
          child: Form(
            key: authNotifier.updateProfileFormKey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: HorizontalAnimation(
                    duration: 900,
                    child: UserShirt(
                      name: authNotifier.shirtNameController.text,
                      number: authNotifier.shirtNumberController.text,
                      shirtPhoto: storeNotifier.tshirtPic ??
                          authNotifier.userModel.data?.shirtPhoto,
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
                ),
                _textFieldHeader(tr('Shirt Name'), 1000),
                AppTextField(
                  hintText: tr('Shirt Name'),
                  icon: Icons.label,
                  controller: authNotifier.shirtNameController,
                  duration: 1000,
                  validator: (value) => authNotifier.validateShirtName(value),
                  onChanged: (value) => authNotifier.updateShirtNumber(value),
                ),
                const SliverSizedBox(height: 12),
                _textFieldHeader(tr('Shirt Number'), 900),
                AppTextField(
                  hintText: tr('Shirt Number'),
                  icon: Icons.numbers,
                  controller: authNotifier.shirtNumberController,
                  duration: 900,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => authNotifier.updateShirtName(value),
                  validator: (value) => authNotifier.validateShirtNumber(value),
                ),
                const SliverSizedBox(height: 16),
                _divider(),
                if (!widget.isFromAppleAuth) ...{
                  const SliverSizedBox(height: 16),
                  _textFieldHeader(tr('First Name'), 800),
                  AppTextField(
                    hintText: tr('First Name'),
                    icon: Icons.person,
                    controller: authNotifier.firstNameController,
                    duration: 800,
                    validator: (value) =>
                        authNotifier.validateFirstNameUpdateProfile(value),
                  ),
                  const SliverSizedBox(height: 12),
                  _textFieldHeader(tr('Last Name'), 700),
                  AppTextField(
                    hintText: tr('Last Name'),
                    icon: Icons.person,
                    controller: authNotifier.lastNameController,
                    duration: 700,
                    validator: (value) =>
                        authNotifier.validateLastNameUpdateProfile(value),
                  ),
                },
                if (Platform.isAndroid) ...{
                  const SliverSizedBox(height: 12),
                  _textFieldHeader(tr('Phone'), 700),
                  AppTextField(
                    hintText: tr('Phone'),
                    icon: Icons.phone,
                    controller: authNotifier.phoneController,
                    keyboardType: TextInputType.number,
                    duration: 700,
                    // validator: (value) =>
                    //     authNotifier.validateLastNameUpdateProfile(value),
                  ),
                },
                const SliverSizedBox(height: 12),

                ///TODO country error
                _textFieldHeader(tr('Country'), 700),
                SliverToBoxAdapter(
                  child: HorizontalAnimation(
                    duration: 400,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: kColorCard,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(
                            Icons.public,
                            color: kColorIconHomeHint,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton(
                              isExpanded: true,
                              hint: Text(
                                'Country',
                                style: Get.textTheme.titleSmall?.copyWith(
                                  fontFamily: "Algerian",
                                  color: Colors.white,
                                ),
                              ).tr(),
                              selectedItemBuilder: (context) => authNotifier
                                  .countries
                                  .map<DropdownMenuItem<CountryModel>>(
                                (CountryModel country) {
                                  return DropdownMenuItem<CountryModel>(
                                    value: country,
                                    child: Text(
                                      (context.locale.languageCode == 'ar'
                                              ? country.arName
                                              : country.name) ??
                                          "",
                                      style:
                                          Get.textTheme.titleMedium!.copyWith(
                                        fontFamily: "Algerian",
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                              underline: const SizedBox.shrink(),
                              dropdownColor: kColorBackground,
                              value: selectedCountry,
                              onChanged: (newValue) {
                                selectedCountry = newValue;
                                setState(() {});
                              },
                              items: authNotifier.countries
                                  .map<DropdownMenuItem<CountryModel>>(
                                (CountryModel country) {
                                  return DropdownMenuItem<CountryModel>(
                                    value: country,
                                    child: Text(
                                      (context.locale.languageCode == 'ar'
                                              ? country.arName
                                              : country.name) ??
                                          "",
                                      style:
                                          Get.textTheme.titleMedium!.copyWith(
                                        fontFamily: "Algerian",
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /////////////////////////////////////////////////
                // if (!widget.isFromAuth) ...{
                //   const SliverSizedBox(height: 12),
                //   _textFieldHeader('Username', 600),
                //   AppTextField(
                //     hintText: 'Username',
                //     icon: Icons.person,
                //     controller: authNotifier.usernameController,
                //     duration: 600,
                //     validator: (value) =>
                //         authNotifier.validateUsernameUpdateProfile(value),
                //   ),
                // },

                if (Platform.isAndroid) ...{
                  const SliverSizedBox(height: 12),
                  _textFieldHeader(tr('Birth Date'), 500),
                  AppTextField(
                    hintText: tr('Birth Date'),
                    readOnly: true,
                    onTap: () async {
                      await _selectDate();
                    },
                    icon: Icons.date_range,
                    controller: authNotifier.birthDateController,
                    keyboardType: TextInputType.datetime,
                    duration: 500,
                    validator: Platform.isIOS
                        ? null
                        : (value) => authNotifier.validateBirthDate(value),
                  ),
                  const SliverSizedBox(height: 12),
                  _textFieldHeader(tr('Gender'), 400),
                  SliverToBoxAdapter(
                    child: HorizontalAnimation(
                      duration: 400,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: kColorCard,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Icon(
                              Icons.male,
                              color: kColorIconHomeHint,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButton(
                                selectedItemBuilder: (context) =>
                                    genderMap.keys.map<DropdownMenuItem<int>>(
                                  (String gender) {
                                    return DropdownMenuItem<int>(
                                      value: genderMap[gender],
                                      child: Text(
                                        gender,
                                        style:
                                            Get.textTheme.titleMedium!.copyWith(
                                          fontFamily: "Algerian",
                                          color: genderMap[gender] == 0
                                              ? kColorIconHomeHint
                                              : Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                                underline: const SizedBox.shrink(),
                                isExpanded: true,
                                dropdownColor: kColorBackground,
                                value: authNotifier.gender,
                                onChanged: (newValue) {
                                  authNotifier.setGender(newValue);
                                },
                                items:
                                    genderMap.keys.map<DropdownMenuItem<int>>(
                                  (String gender) {
                                    return DropdownMenuItem<int>(
                                      value: genderMap[gender],
                                      child: Text(
                                        gender,
                                        style:
                                            Get.textTheme.titleMedium!.copyWith(
                                          fontFamily: "Algerian",
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                },
                const SliverSizedBox(height: 32),
                !authNotifier.updateProfileLoading
                    ? SliverToBoxAdapter(
                        child: HorizontalAnimation(
                          duration: 1000,
                          child: FilledButton(
                            onPressed: () async {
                              if (!authNotifier
                                  .updateProfileFormKey.currentState!
                                  .validate()) {
                                if (!_autoValidate) {
                                  setState(() => _autoValidate = true);
                                }
                                return;
                              }
                              UpdateProfileParam param = UpdateProfileParam(
                                birthDate:
                                    authNotifier.birthDateController.text,
                                firstName:
                                    authNotifier.firstNameController.text,
                                lastName: authNotifier.lastNameController.text,
                                userName: authNotifier.usernameController.text,
                                shirtName:
                                    authNotifier.shirtNameController.text,
                                shirtNumber: int.parse(
                                  authNotifier.shirtNumberController.text,
                                ),
                                gender:
                                    Platform.isIOS ? 1 : authNotifier.gender,
                                countryId: selectedCountry?.id,
                              );
                              await authNotifier.updateProfile(param);
                              if (widget.isFromAuth) {
                                Get.offAndToNamed('/welcome');
                              }
                            },
                            child: Text(
                              widget.isFromAuth ? kFinish : tr('Submit'),
                              style: const TextStyle(fontFamily: 'Algerian'),
                            ),
                          ),
                        ),
                      )
                    : const AppLoadingIndicator(),
                const SliverSizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}

Widget _divider() => SliverToBoxAdapter(
      child: HorizontalAnimation(
        duration: 850,
        child: Divider(
          thickness: 1,
          height: 5,
          color: Colors.grey.shade500,
        ),
      ),
    );
