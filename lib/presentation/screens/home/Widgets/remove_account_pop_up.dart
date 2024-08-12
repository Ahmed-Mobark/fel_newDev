import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:football_app/presentation/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class RemoveAccountPopUp extends StatelessWidget {
  const RemoveAccountPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);

    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(13.0))),
      insetPadding: const EdgeInsets.all(60),
      contentPadding: const EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tr('Remove Account'),
              style: const TextStyle(
                color: Color(0xFFFF5357),
                fontSize: 12,
                fontFamily: "Algerian",
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sure Remove Account',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: "Algerian",
              ),
            ).tr(),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                    authNotifier.removeAccount();
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF5357),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tr('Remove Account'),
                      style: const TextStyle(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tr('Cancel'),
                      style: const TextStyle(
                        fontFamily: "Algerian",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
