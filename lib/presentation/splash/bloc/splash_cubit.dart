import 'package:flutter_bloc/flutter_bloc.dart';

class SplashCubit extends Cubit<bool> {
  SplashCubit() : super(false);

  void appStarted() async {
    await Future.delayed(const Duration(milliseconds: 600));
    emit(true);
  }
}
