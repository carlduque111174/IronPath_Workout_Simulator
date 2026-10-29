import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironpath_workout_simulator/presentation/auth/pages/siginin.dart';
import 'package:ironpath_workout_simulator/presentation/splash/bloc/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, bool>(
      listener: (context, state) {
        if (state) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => SigninPage()));
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1B3E),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Sign in',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(color: Color(0xFFB07BFF)),
            ],
          ),
        ),
      ),
    );
  }
}
