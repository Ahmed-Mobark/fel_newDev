import 'package:flutter/material.dart';
import 'package:football_app/presentation/notifiers/auth_notifier.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class PasswordFieldObscureTextButton extends StatelessWidget {
  const PasswordFieldObscureTextButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    return IconButton(
      onPressed: authNotifier.toggleIsObscure,
      icon: Icon(
        authNotifier.isObscure ? Ionicons.eye : Ionicons.eye_off,
        color: Colors.white,
      ),
    );
  }
}
