abstract class AgesDisplayState {}

class AgesLoading extends AgesDisplayState {}

class AgesLoaded extends AgesDisplayState {
  final List<String> ages;
  AgesLoaded({required this.ages});
}

class AgesLoadFailure extends AgesDisplayState {
  final String message;

  AgesLoadFailure({required this.message});
}
