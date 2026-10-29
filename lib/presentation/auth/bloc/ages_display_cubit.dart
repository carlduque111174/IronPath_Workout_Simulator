import 'package:ironpath_workout_simulator/domain/auth/usecases/get_ages.dart';
import 'package:ironpath_workout_simulator/presentation/auth/bloc/ages_display_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';

class AgesDisplayCubit extends Cubit<AgesDisplayState> {
  AgesDisplayCubit() : super(AgesLoading());

  void displayAges() async {
    try {
      final ages = await sl<GetAgesUseCase>().call();
      emit(AgesLoaded(ages: ages));
    } catch (error) {
      emit(AgesLoadFailure(message: error.toString()));
    }
  }
}
