import 'package:ironpath_workout_simulator/data/auth/models/user_creation_req.dart';

class SignupUseCase {
  Future<void> call({required UserCreationReq params}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return;
  }
}
