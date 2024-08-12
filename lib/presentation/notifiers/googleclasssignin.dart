import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInApi {
  static final _googlesignIn = GoogleSignIn(
    scopes: <String>[
         'email',
          'https://www.googleapis.com/auth/contacts.readonly',
          "https://www.googleapis.com/auth/userinfo.profile"
],
  //  scopes: [
  //   'https://www.googleapis.com/auth/drive',
  // ],
  );

  static Future<GoogleSignInAccount?> login() => _googlesignIn.signIn();
  static Future<GoogleSignInAccount?> logout() => _googlesignIn.disconnect();
}
