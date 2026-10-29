import 'package:ironpath_workout_simulator/common/helper/navigator/app_navigator.dart';
import 'package:ironpath_workout_simulator/common/widgets/button/basic_app_button.dart';
import 'package:ironpath_workout_simulator/presentation/auth/pages/siginin.dart';
import 'package:flutter/material.dart';

class PasswordResetEmailPage extends StatelessWidget {
  const PasswordResetEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _emailSending(),
          const SizedBox(height: 30),
          _sentEmail(),
          const SizedBox(height: 30),
          _returnToLoginButton(context),
        ],
      ),
    );
  }

  Widget _emailSending() {
    return const Center(
      child: Icon(Icons.email_outlined, size: 120, color: Color(0xFFB07BFF)),
    );
  }

  Widget _sentEmail() {
    return const Center(
      child: Text('We Sent you an Email to reset your password.'),
    );
  }

  Widget _returnToLoginButton(BuildContext context) {
    return BasicAppButton(
      onPressed: () {
        AppNavigator.pushReplacement(context, SigninPage());
      },
      width: 200,
      title: 'Return to Login',
    );
  }
}
