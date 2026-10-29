import 'dart:async';

import 'package:flutter/foundation.dart';

class Equipment {
  Equipment({
    required this.name,
    required this.type,
    required this.weight,
    required this.exercise,
    this.available = true,
  });

  String name;
  String type;
  double weight;
  String exercise;
  bool available;
}

class WorkoutActivity {
  WorkoutActivity({
    required this.day,
    required this.name,
    required this.focus,
    this.isRestDay = false,
    this.status = 'Planned',
  });

  final String day;
  final String name;
  final String focus;
  final bool isRestDay;
  String status;
}

class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  final List<Equipment> equipment = [];
  final List<WorkoutActivity> activities = [
    WorkoutActivity(
      day: 'Monday',
      name: 'Chest and Triceps',
      focus: 'Push strength',
    ),
    WorkoutActivity(
      day: 'Tuesday',
      name: 'Back and Biceps',
      focus: 'Pull strength',
    ),
    WorkoutActivity(
      day: 'Wednesday',
      name: 'Shoulders and Abs',
      focus: 'Upper body and core',
    ),
    WorkoutActivity(day: 'Thursday', name: 'Leg Day', focus: 'Lower body'),
    WorkoutActivity(
      day: 'Friday',
      name: 'Rest Day',
      focus: 'Recovery',
      isRestDay: true,
    ),
    WorkoutActivity(
      day: 'Saturday',
      name: 'Rest Day',
      focus: 'Recovery',
      isRestDay: true,
    ),
    WorkoutActivity(
      day: 'Sunday',
      name: 'Rest Day',
      focus: 'Recovery',
      isRestDay: true,
    ),
  ];
  int completedWorkouts = 0;
  int activeMinutes = 0;
  double trainingVolume = 0;
  final Set<String> _selectedFocus = {'Arms'};
  final Set<String> _selectedWorkoutEquipment = {'Barbell'};
  final Stopwatch _workoutStopwatch = Stopwatch();
  Timer? _workoutTimer;
  WorkoutActivity? _activeActivity;
  bool isWorkoutActive = false;

  static const workoutDurationGoal = Duration(minutes: 30);

  Set<String> get selectedFocus => Set.unmodifiable(_selectedFocus);
  Set<String> get selectedWorkoutEquipment =>
      Set.unmodifiable(_selectedWorkoutEquipment);
  Duration get workoutElapsed => _workoutStopwatch.elapsed;
  double get workoutProgress =>
      (workoutElapsed.inMilliseconds / workoutDurationGoal.inMilliseconds)
          .clamp(0.0, 1.0);

  bool get hasProgress => completedWorkouts > 0;
  bool get hasEquipment => equipment.isNotEmpty;

  void addEquipment(Equipment item) {
    equipment.add(item);
    notifyListeners();
  }

  void updateEquipment(Equipment oldItem, Equipment updatedItem) {
    final index = equipment.indexOf(oldItem);
    if (index == -1) return;
    equipment[index] = updatedItem;
    notifyListeners();
  }

  void removeEquipment(Equipment item) {
    equipment.remove(item);
    notifyListeners();
  }

  void toggleFocus(String focus) {
    if (!_selectedFocus.add(focus)) {
      _selectedFocus.remove(focus);
    }
    notifyListeners();
  }

  void toggleWorkoutEquipment(String item) {
    if (!_selectedWorkoutEquipment.add(item)) {
      _selectedWorkoutEquipment.remove(item);
    }
    notifyListeners();
  }

  void startWorkout() {
    if (isWorkoutActive) return;

    if (_activeActivity == null) {
      for (final activity in activities) {
        if (!activity.isRestDay && activity.status == 'Planned') {
          _activeActivity = activity;
          break;
        }
      }
    }
    final activeActivity = _activeActivity;
    if (activeActivity != null && !activeActivity.isRestDay) {
      activeActivity.status = 'In progress';
    }

    _workoutStopwatch
      ..reset()
      ..start();
    isWorkoutActive = true;
    _workoutTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => notifyListeners(),
    );
    notifyListeners();
  }

  void finishWorkout() {
    if (!isWorkoutActive) return;

    _workoutStopwatch.stop();
    _workoutTimer?.cancel();
    _workoutTimer = null;
    isWorkoutActive = false;

    if (_activeActivity != null && !_activeActivity!.isRestDay) {
      _activeActivity!.status = 'Completed';
      completedWorkouts++;
    }
    activeMinutes += workoutElapsed.inMinutes;
    trainingVolume += equipment.fold<double>(
      0,
      (total, item) => total + item.weight,
    );
    _activeActivity = null;
    notifyListeners();
  }

  void startActivity(WorkoutActivity activity) {
    if (activity.isRestDay || activity.status == 'Completed') return;
    if (isWorkoutActive) return;
    _activeActivity = activity;
    startWorkout();
  }

  void completeActivity(WorkoutActivity activity) {
    if (activity.status == 'Completed') return;
    if (!isWorkoutActive) {
      _activeActivity = activity;
    } else {
      _activeActivity = activity;
    }
    if (!isWorkoutActive) startWorkout();
    finishWorkout();
  }

  void addActivity(String name) {
    activities.add(
      WorkoutActivity(day: 'Custom', name: name, focus: 'Bodyweight'),
    );
    notifyListeners();
  }
}
