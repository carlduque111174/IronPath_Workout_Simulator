import 'package:flutter_test/flutter_test.dart';
import 'package:ironpath_workout_simulator/app_state.dart';

void main() {
  final state = AppState.instance;

  test('focus and workout equipment selections toggle independently', () {
    expect(state.selectedFocus, contains('Arms'));
    state.toggleFocus('Arms');
    state.toggleFocus('Chest');
    expect(state.selectedFocus, isNot(contains('Arms')));
    expect(state.selectedFocus, contains('Chest'));

    expect(state.selectedWorkoutEquipment, contains('Barbell'));
    state.toggleWorkoutEquipment('Barbell');
    state.toggleWorkoutEquipment('Dumbbell');
    expect(state.selectedWorkoutEquipment, isNot(contains('Barbell')));
    expect(state.selectedWorkoutEquipment, contains('Dumbbell'));

    state.toggleFocus('Arms');
    state.toggleFocus('Chest');
    state.toggleWorkoutEquipment('Barbell');
    state.toggleWorkoutEquipment('Dumbbell');
  });

  test(
    'starting a workout tracks elapsed time and finishing stops it',
    () async {
      state.startWorkout();
      expect(state.isWorkoutActive, isTrue);

      await Future<void>.delayed(const Duration(seconds: 1));

      expect(
        state.workoutElapsed,
        greaterThanOrEqualTo(const Duration(seconds: 1)),
      );
      expect(state.workoutProgress, greaterThan(0));

      state.finishWorkout();
      final finishedTime = state.workoutElapsed;
      expect(state.isWorkoutActive, isFalse);

      await Future<void>.delayed(const Duration(milliseconds: 1100));
      expect(state.workoutElapsed, finishedTime);
    },
  );
}
