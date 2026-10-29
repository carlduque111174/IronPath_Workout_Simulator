import 'package:bloc/bloc.dart';
import 'button_state.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  Future<void> execute({
    required dynamic usecase,
    required dynamic params,
  }) async {
    emit(ButtonLoadingState());
    try {
      if (params != null) {
        await usecase.call(params: params);
      } else {
        await usecase.call();
      }
      emit(ButtonSuccessState());
    } catch (error) {
      emit(ButtonFailureState(errorMessage: error.toString()));
    }
  }
}
