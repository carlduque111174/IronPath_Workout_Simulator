import 'package:ironpath_workout_simulator/data/auth/models/user_signin_req.dart';

class SigninUseCase {
  Future<void> call({required UserSigninReq params}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }
}
