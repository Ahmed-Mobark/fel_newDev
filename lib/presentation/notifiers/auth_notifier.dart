// ignore_for_file: unused_catch_stack

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:football_app/data_layer/api/api_provider.dart';
import 'package:football_app/models/forgetpassword/forgetpass_param.dart';
import 'package:football_app/models/home/user_model.dart';
import 'package:football_app/models/signin/apple_signin_param.dart';
import 'package:football_app/models/signin/country_model.dart';
import 'package:football_app/models/signin/guest_model.dart';
import 'package:football_app/models/signin/signin_model.dart';
import 'package:football_app/models/signin/singin_param.dart';
import 'package:football_app/models/signin/socail_param.dart';
import 'package:football_app/models/signup_model/signup_model.dart';
import 'package:football_app/models/signup_model/signup_param.dart';
import 'package:football_app/models/signup_model/verify_email_param.dart';
import 'package:football_app/models/update_profile/update_profile_model.dart';
import 'package:football_app/models/update_profile/update_profile_param.dart';
import 'package:football_app/presentation/screens/edit_profile_settings_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quiver/strings.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../main.dart';
import '../widgets/widgets.dart';

class AuthNotifier extends ChangeNotifier {
  final rxPrefs = RxSharedPreferences(SharedPreferences.getInstance());

  //signup

  // void clearSignupControllers() {
  //   emailController.clear();
  //   nameController.clear();
  //   passwordController.clear();
  //   confirmPasswordController.clear();
  // }

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? userId;
  List<CountryModel> countries = [];

  signup(SignupParam param) async {
    try {
      _isLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .signup(param)
          .then((SignupModel value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSocialLogged = false;
          userId = value.data;
          verificationCodeController.text = '';
          notifyListeners();
          Get.offAndToNamed('/verify', arguments: false);
        }
        //   clearSignupControllers();
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isObscure = true;
  bool get isObscure => _isObscure;

  void toggleIsObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  // void clearLoginControllers() {
  //   loginUsernameController.clear();
  //   loginPasswordController.clear();
  // }

  //signin
  TextEditingController loginUsernameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  bool _removeAccountLoading = false;
  bool _logoutLoading = false;
  bool _loginLoading = false;
  bool isSocialLogged = false;
  bool isLogin = false;
  bool get removeAccountLoading => _removeAccountLoading;
  bool get logoutLoading => _logoutLoading;
  bool get loginLoading => _loginLoading;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgetpassFormKey = GlobalKey<FormState>();
  TextEditingController emailforgetpassController = TextEditingController();

  SigninModel signinModel = SigninModel();
  signin(SigninParam param) async {
    try {
      _loginLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .signin(param)
          .then((SigninModel value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {
          isSocialLogged = false;
          notifyListeners();
          signinModel = value;
          await rxPrefs.setString('token', value.data?.token);
          await rxPrefs.setString('token', value.data?.token);
          await rxPrefs.setString('refreshToken', value.data?.refreshToken);
          await getUserData();
          if (value.data?.isEmailVerified ?? false) {
            if (value.data?.isProfileInit ?? false) {
              Get.offAndToNamed('/welcome');
            } else {
              Get.to(() => const EditProfileSettingsScreen(isFromAuth: true));
            }
          } else {
            isLogin = true;
            notifyListeners();
            Get.offAndToNamed('/verify');
          }
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            errorSnackBar(value.message.toString()),
          );
        }
        _loginLoading = false;

        if (value.error == "unAuthorized") {
          // resendCode();
          Get.offAndToNamed('/verify', arguments: true);
        }
        //  clearLoginControllers();
        notifyListeners();
      });
    } catch (e) {
      _loginLoading = false;
      notifyListeners();
    }
  }

  forgetpass(Forgetpassparam param) async {
    try {
      _loginLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .forgetpassword(param)
          .then((value) async {
        _loginLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _loginLoading = false;
      notifyListeners();
    }
  }

  getCountries() async {
    try {
      _loginLoading = true;
      notifyListeners();
      countries.clear();
      countries = await ApiProvider(httpClient: Dio()).getCountries();
      _loginLoading = false;
      notifyListeners();
    } catch (e) {
      _loginLoading = false;
      notifyListeners();
    }
  }

  logout() async {
    try {
      _logoutLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio()).logout().then((value) async {
        // if (value == "true") {
        //   Get.offAndToNamed('/login');
        // }
        final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
        _logoutLoading = false;
        notifyListeners();
      });
    } catch (e) {
      final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
      rxPrefs.remove('token');
      rxPrefs.remove('guestToken');

      _logoutLoading = false;
      notifyListeners();
    }
  }
  // logout() async {
  //   try {
  //     _logoutLoading = true;
  //     notifyListeners();

  //     await ApiProvider(httpClient: Dio()).logout().then((value) async {
  //       // if (value == "true") {
  //       //   Get.offAndToNamed('/login');
  //       // }
  //       _logoutLoading = false;
  //       notifyListeners();
  //     });
  //   } catch (e) {
  //
  //     _logoutLoading = false;
  //     notifyListeners();
  //   }
  // }

  resendCode(String userId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio())
          .resendCode(userId)
          .then((value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {}
        _isLoading = false;

        //  clearLoginControllers();
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  changeLang(String lang) async {
    try {
      _isLoading = true;
      notifyListeners();

      await ApiProvider(httpClient: Dio()).changeLang(lang).then((value) async {
        _isLoading = false;

        //  clearLoginControllers();
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  changeNumberOfCoins(int price) {
    try {
      userModel.data!.coinsBalance = (userModel.data!.coinsBalance! - price);
      notifyListeners();
    } catch (e) {
      _loginLoading = false;
      notifyListeners();
    }
  }

  String? validateLoginUsername(String? value) {
    if (value!.isEmpty) {
      return tr('This field cannot be empty');
    }
    return null;
  }

  String? validateLoginPassword(String? value) {
    if (value!.isEmpty) {
      return tr('This field cannot be empty');
    }
    if (value.length <= 8) {
      return tr('Please enter a valid password');
    }
    return null;
  }

  //get user model
  bool _userLoading = false;
  bool get userLoading => _userLoading;

  UserModel userModel = UserModel();

  getUserData() async {
    try {
      _userLoading = true;
      await ApiProvider(httpClient: Dio())
          .getUserData()
          .then((UserModel value) {
        userModel = value;

        _userLoading = false;
        notifyListeners();
      });
    } catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        errorSnackBar(e.toString()),
      );
      _userLoading = false;
      notifyListeners();
    }
  }

  // update user photo
  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;
  selectUserPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      log('file path = ${file.path}');
      updateUserPhoto(file.path);
    }
  }

  updateUserPhoto(String path) async {
    try {
      _updateLoading = true;
      await ApiProvider(httpClient: Dio()).updateUserPhoto(path).then((value) {
        _updateLoading = false;
        getUserData();
        notifyListeners();
      });
    } catch (e) {
      _updateLoading = false;
      notifyListeners();
    }
  }

//update profile photo
  selectProfilePhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      log('file path = ${file.path}');
      updateProfilePhoto(file.path);
    }
  }

  updateProfilePhoto(String path) async {
    try {
      _updateLoading = true;
      await ApiProvider(httpClient: Dio())
          .updateProfilePhoto(path)
          .then((value) {
        _updateLoading = false;
        getUserData();
        notifyListeners();
      });
    } catch (e) {
      _updateLoading = false;
      notifyListeners();
    }
  }

  // update profile
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController birthDateController;
  late TextEditingController shirtNumberController;
  late TextEditingController shirtNameController;
  int? gender;

  void setGender(int? newGender) {
    gender = newGender;
    notifyListeners();
  }

  void updateShirtName(String name) {
    name = shirtNameController.text;
    notifyListeners();
  }

  void updateShirtNumber(String number) {
    number = shirtNumberController.text;
    notifyListeners();
  }

  Map<String, int> genderMap = {
    tr('Please choose a gender'): 0,
    tr('Male'): 1,
    tr('Female'): 2,
  };

  bool _updateProfileLoading = false;
  bool get updateProfileLoading => _updateProfileLoading;
  final updateProfileFormKey = GlobalKey<FormState>();

  String? validateShirtNumber(String? value) {
    if (isBlank(value)) {
      return tr('This field cannot be empty');
    }
    if (value == '0') {
      return tr('Field must not be zero');
    }
    if (value!.length > 2) {
      return tr('Field must contain only 2 numbers');
    }
    return null;
  }

  String? validateShirtName(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    if (value!.length > 8) {
      return tr('Field must not be longer that 8 letters');
    }
    return null;
  }

  String? validateFirstNameUpdateProfile(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    if (value!.length < 3) {
      return tr('This field must at least have 3 letters');
    }
    return null;
  }

  String? validateLastNameUpdateProfile(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    if (value!.length < 3) {
      return tr('This field must at least have 3 letters');
    }
    return null;
  }

  String? validateUsernameUpdateProfile(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    if (value!.length <= 8) {
      return tr('This field must at least have 8 letters');
    }
    return null;
  }

  String? validateBirthDate(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }

    final RegExp dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!dateRegex.hasMatch(value!)) {
      return tr('Please enter a valid date in the format YYYY-MM-DD');
    }

    return null;
  }

  updateProfile(UpdateProfileParam param) async {
    _updateProfileLoading = true;
    notifyListeners();
    try {
      await ApiProvider(httpClient: Dio()).updateProfile(param).then(
        (UpdateProfileModel value) {
          if (value.statusCode == 200 || value.statusCode == 201) {
            Get.toNamed('/welcome');
            getUserData();
          }
          _updateProfileLoading = false;
          notifyListeners();
        },
      );
    } catch (e, s) {
      _updateProfileLoading = false;
      notifyListeners();
    }
    getUserData();
  }

  TextEditingController forgetPasswordEmailController = TextEditingController();
  bool _forgetPasswordLoading = false;
  bool get forgetPasswordLoading => _forgetPasswordLoading;
  final forgetPasswordFormKey = GlobalKey<FormState>();

  forgetPassword(String email) async {
    _forgetPasswordLoading = true;
    notifyListeners();
    try {
      await ApiProvider(httpClient: Dio()).forgetPassword(email);
      Get.back();
    } catch (e) {
      _forgetPasswordLoading = false;
      notifyListeners();
    }
  }

  TextEditingController verificationCodeController = TextEditingController();
  bool _verificationCodeLoading = false;
  bool get verificationCodeLoading => _verificationCodeLoading;

  verifyEmailCheck(VerifyEmailParam param) async {
    _verificationCodeLoading = true;
    notifyListeners();
    try {
      final response = await ApiProvider(httpClient: Dio()).verifyEmail(param);
      // Get.back();
      // print('tyguhj');

      _verificationCodeLoading = false;
      notifyListeners();

      if (response['isVerified']) {
        if (isLogin) {
          if (signinModel.data?.isProfileInit ?? false) {
            Get.offAndToNamed('/welcome');
          } else {
            Get.to(() => const EditProfileSettingsScreen(isFromAuth: true));
          }
        } else {
          Get.offAndToNamed('/login');
          // if (!(signinModel.data?.isProfileInit ?? false)) {
          //   Get.to(() => const EditProfileSettingsScreen(isFromAuth: true));
          // } else {
          //   Get.offAndToNamed('/welcome');
          // }
        }
        isLogin = false;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          errorSnackBar(tr('check_code')),
        );
      }
    } catch (e) {
      _verificationCodeLoading = false;
      notifyListeners();
    }
  }

  //visitor login
  bool _visitorLoading = false;
  bool get visitorLoading => _visitorLoading;
  visitorLogin() async {
    _visitorLoading = true;
    try {
      await ApiProvider(httpClient: Dio()).visitorSignIn().then(
        (GuestModel value) async {
          if (value.statusCode == 200 || value.statusCode == 201) {
            Get.toNamed('/welcome');
            await rxPrefs.setString('guestToken', value.data?.token);
            getUserData();
          }
          _visitorLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _visitorLoading = false;
      notifyListeners();
    }
  }

  /////////// social login
  Future appleAuth(BuildContext context) async {
    try {
      _loginLoading = true;
      notifyListeners();
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          // AppleIDAuthorizationScopes.fullName,
        ],
      );

      log(appleCredential.authorizationCode);
      log('appleCredential.identityToken =${appleCredential.identityToken}');
      log('appleCredential.userIdentifier =${appleCredential.userIdentifier}');
      log('appleCredential.email =${appleCredential.email}');
      log('appleCredential.familyName =${appleCredential.familyName}');
      log('appleCredential.givenName =${appleCredential.givenName}');
      log('appleCredential.state =${appleCredential.state}');
      AppleSigninParam param = AppleSigninParam(
        identityToken: appleCredential.identityToken,
        userIdentifier: appleCredential.userIdentifier,
        email: appleCredential.email,
        familyName: appleCredential.familyName,
        givenName: appleCredential.givenName,
      );
      await ApiProvider(httpClient: Dio())
          .appleSignin(param)
          .then((SigninModel value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {
          signinModel = value;
          await rxPrefs.setString('token', value.data?.token);
          await rxPrefs.setString('refreshToken', value.data?.refreshToken);
          await getUserData();
          if (!(signinModel.data?.isProfileInit ?? false)) {
            isSocialLogged = true;
            notifyListeners();
            Get.to(
              () => const EditProfileSettingsScreen(
                isFromAuth: true,
                isFromAppleAuth: true,
              ),
            );
          } else {
            Get.offAndToNamed('/welcome');
          }
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            errorSnackBar(value.message.toString()),
          );
        }
        // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        //   errorSnackBar(value.message.toString()),
        // );
        //  clearLoginControllers();
        _loginLoading = false;
        notifyListeners();
      });
    } catch (error, trace) {
      _loginLoading = false;
      notifyListeners();
    }
  }

//////
  Future<List<String>?> googleAuth(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount;
    GoogleSignInAuthentication? googleSignInAuthentication;
    try {
      _loginLoading = true;
      notifyListeners();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount == null) {
        return throw "Couldn't Sign you in, Please try again in a moment";
      }
      googleSignInAuthentication = await googleSignInAccount.authentication;
      log(googleSignInAuthentication.idToken ?? "");

      // ///TODO : remove
      // if (DateTime.now().isBefore(DateTime(2023, 11, 16))) {
      //   showDialog(
      //       context: context,
      //       builder: (_) => AlertDialog(
      //             content: SingleChildScrollView(
      //               child: Column(
      //                 children: [
      //                   IconButton(
      //                       onPressed: () {
      //                         Clipboard.setData(ClipboardData(
      //                             text: googleSignInAuthentication?.idToken ??
      //                                 ''));
      //                       },
      //                       icon: Icon(Icons.copy)),
      //                   SelectableText(
      //                       googleSignInAuthentication?.idToken ?? ''),
      //                 ],
      //               ),
      //             ),
      //           ));
      // }

      SocialParam param =
          SocialParam(token: googleSignInAuthentication.idToken);
      await ApiProvider(httpClient: Dio())
          .googleSignIn(param)
          .then((SigninModel value) async {
        if (value.statusCode == 200 || value.statusCode == 201) {
          signinModel = value;
          await rxPrefs.setString('token', value.data?.token);
          await rxPrefs.setString('refreshToken', value.data?.refreshToken);
          await getUserData();
          if (!(signinModel.data?.isProfileInit ?? false)) {
            isSocialLogged = true;
            notifyListeners();
            Get.to(() => const EditProfileSettingsScreen(isFromAuth: true));
          } else {
            Get.offAndToNamed('/welcome');
          }
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            errorSnackBar(value.message.toString()),
          );
        }
        _loginLoading = false;
        notifyListeners();
      });
    } catch (error, trace) {
      _loginLoading = false;
      notifyListeners();
    }
    return <String>[
      googleSignInAccount?.displayName ?? '',
      googleSignInAuthentication?.accessToken ?? '',
    ];
  }

/////facebook
// ignore: body_might_complete_normally_nullable
  Future<List<String>?> facebookAuth(BuildContext context) async {
    // Create an instance of FacebookLogin
    final FacebookLogin fb = FacebookLogin();

    // Log in
    final FacebookLoginResult res = await fb.logIn(
      permissions: <FacebookPermission>[
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );
    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
        // Logged in

        final FacebookAccessToken accessToken = res.accessToken!;
        SocialParam param = SocialParam(token: accessToken.token);
        // Get profile data
        final FacebookUserProfile? profile = await fb.getUserProfile();
        // Get user profile image url
        final String? imageUrl = await fb.getProfileImageUrl(width: 100);
        // ignore: use_build_context_synchronously
        // await executeSocialAuth(
        //     context, SocialAuthEnum.facebook.rawValue, accessToken.token);
        try {
          _loginLoading = true;
          notifyListeners();
          await ApiProvider(httpClient: Dio())
              .facebookLogin(param)
              .then((SigninModel value) async {
            if (value.statusCode == 200 || value.statusCode == 201) {
              signinModel = value;
              await rxPrefs.setString('token', value.data?.token);
              await rxPrefs.setString('refreshToken', value.data?.refreshToken);
              await getUserData();
              if (!(signinModel.data?.isProfileInit ?? false)) {
                isSocialLogged = true;
                notifyListeners();
                Get.to(() => const EditProfileSettingsScreen(isFromAuth: true));

                // Navigator.pop(context);
                //
                // Navigator.push(
                //     context,
                //     CupertinoPageRoute(
                //         builder: (_) =>
                //             const RegisterSecondScreen(isSocial: true)));
              } else {
                Get.offAndToNamed('/welcome');
              }
            } else {
              ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
                errorSnackBar(value.message.toString()),
              );
            }
            // ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            //   errorSnackBar(value.message.toString()),
            // );
            //  clearLoginControllers();
            _loginLoading = false;
            notifyListeners();
          });
        } catch (error, trace) {
          _loginLoading = false;
          notifyListeners();
        }
        return <String>[imageUrl!, profile?.name ?? 'N/A', accessToken.token];
      case FacebookLoginStatus.cancel:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        break;
    }
  }

  setLang(String lang, BuildContext context) {
    if (lang == 'english') {
      Get.updateLocale(const Locale('en'));
      Get.deviceLocale == const Locale('en');
      context.setLocale(
        const Locale('en'),
      );
    } else if (lang == 'portuguese') {
      Get.deviceLocale == const Locale('pt');
      Get.updateLocale(const Locale('pt'));
      context.setLocale(
        const Locale('pt'),
      );
    } else if (lang == 'spanish') {
      Get.deviceLocale == const Locale('es');
      Get.updateLocale(const Locale('es'));
      context.setLocale(
        const Locale('es'),
      );
    } else if (lang == 'arabic') {
      Get.deviceLocale == const Locale('ar');
      Get.updateLocale(const Locale('ar'));
      context.setLocale(
        const Locale('ar'),
      );
    }
    log(context.locale.toString());
    log(context.locale.languageCode.toString());

    notifyListeners();
  }

  removeAccount() async {
    try {
      _removeAccountLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio()).removeAccount().then((value) async {
        // if (value == "true") {
        //   Get.offAndToNamed('/login');
        // }
        final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
        rxPrefs.remove('token');
        rxPrefs.remove('guestToken');
        _removeAccountLoading = false;
        notifyListeners();
      });
    } catch (e) {
      final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
      rxPrefs.remove('token');
      rxPrefs.remove('guestToken');

      _removeAccountLoading = false;
      notifyListeners();
    }
  }

  sendSupport(String title, String desc) async {
    try {
      _removeAccountLoading = true;
      notifyListeners();
      await ApiProvider(httpClient: Dio())
          .sendSupport(title, desc, type!)
          .then((value) async {
        Get.back();

        _removeAccountLoading = false;
        notifyListeners();
      });
    } catch (e) {
      final RxSharedPreferences rxPrefs = RxSharedPreferences.getInstance();
      rxPrefs.remove('token');
      rxPrefs.remove('guestToken');

      _removeAccountLoading = false;
      notifyListeners();
    }
  }

  int? type = 0;

  void setType(int? value) {
    type = value;
    notifyListeners();
  }

  String? validateTitle(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    return null;
  }

  String? validateDesc(String? value) {
    if (isBlank(value)) {
      return tr('Field must not be empty');
    }
    return null;
  }
}
