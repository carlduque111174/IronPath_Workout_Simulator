import 'package:get_it/get_it.dart';
import 'package:ironpath_workout_simulator/domain/auth/usecases/get_ages.dart';
import 'package:ironpath_workout_simulator/domain/auth/usecases/signin.dart';
import 'package:ironpath_workout_simulator/domain/auth/usecases/siginup.dart';
import 'package:ironpath_workout_simulator/domain/auth/usecases/send_password_reset_email.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerLazySingleton(() => SigninUseCase());
  sl.registerLazySingleton(() => SignupUseCase());
  sl.registerLazySingleton(() => SendPasswordResetEmailUseCase());
  sl.registerLazySingleton(() => GetAgesUseCase());
}
