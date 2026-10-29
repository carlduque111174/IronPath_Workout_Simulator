import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'additional_pages.dart';
import 'app_state.dart';
import 'equipment_inventory_page.dart';
import 'ironpath_workout_simulator_products_page.dart';
import 'live_simulator_page.dart';
import 'performance_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _accent = Color(0xFFB7FF5A);

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final appState = AppState.instance;

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final totalWeight = appState.equipment.fold<double>(
          0,
          (total, item) => total + item.weight,
        );

        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF5F7F0);

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: const Text('IronPath'),
            backgroundColor: Colors.transparent,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            elevation: 0,
          ),
          drawer: _buildDrawer(context, user),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Workout Summary',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Progress is looking strong this week',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: _accent.withValues(alpha: 0.18),
                    child: const Icon(Icons.notifications_none, color: _accent),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'Weight loss',
                      value: '15%',
                      subValue: '+3.4kg',
                      color: _accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _MetricCard(
                      label: 'Goal',
                      value: '75%',
                      subValue: '8/12',
                      color: const Color(0xFF7CFFB6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF171E2A) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s focus',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${appState.selectedFocus.length} selected',
                            style: const TextStyle(color: _accent),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _MuscleChip(
                            label: 'Arms',
                            active: appState.selectedFocus.contains('Arms'),
                            onTap: () => appState.toggleFocus('Arms'),
                          ),
                        ),
                        Expanded(
                          child: _MuscleChip(
                            label: 'Chest',
                            active: appState.selectedFocus.contains('Chest'),
                            onTap: () => appState.toggleFocus('Chest'),
                          ),
                        ),
                        Expanded(
                          child: _MuscleChip(
                            label: 'Back',
                            active: appState.selectedFocus.contains('Back'),
                            onTap: () => appState.toggleFocus('Back'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _MuscleChip(
                            label: 'Abs',
                            active: appState.selectedFocus.contains('Abs'),
                            onTap: () => appState.toggleFocus('Abs'),
                          ),
                        ),
                        Expanded(
                          child: _MuscleChip(
                            label: 'Leg',
                            active: appState.selectedFocus.contains('Leg'),
                            onTap: () => appState.toggleFocus('Leg'),
                          ),
                        ),
                        Expanded(
                          child: _MuscleChip(
                            label: 'Body',
                            active: appState.selectedFocus.contains('Body'),
                            onTap: () => appState.toggleFocus('Body'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStat(label: 'Burn', value: '536 kcal'),
                        ),
                        Expanded(
                          child: _MiniStat(label: 'Volume', value: '${totalWeight.toStringAsFixed(0)} kg'),
                        ),
                        Expanded(
                          child: _MiniStat(
                            label: 'Time',
                            value: appState.isWorkoutActive
                                ? _formatElapsed(appState.workoutElapsed)
                                : '${appState.activeMinutes} min',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appState.isWorkoutActive
                              ? 'Workout in progress'
                              : 'Workout progress',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${(appState.workoutProgress * 100).round()}%',
                          style: const TextStyle(
                            color: _accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: appState.workoutProgress,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(999),
                      backgroundColor: isDark
                          ? const Color(0xFF0D1117)
                          : const Color(0xFFE7EBDD),
                      color: _accent,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appState.isWorkoutActive
                          ? '${_formatElapsed(appState.workoutElapsed)} elapsed • 30 min goal'
                          : 'Start a workout to track your 30 min goal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Equipment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _EquipmentTile(
                    label: 'Barbell',
                    active: appState.selectedWorkoutEquipment.contains(
                      'Barbell',
                    ),
                    onTap: () => appState.toggleWorkoutEquipment('Barbell'),
                  ),
                  _EquipmentTile(
                    label: 'Dumbbell',
                    active: appState.selectedWorkoutEquipment.contains(
                      'Dumbbell',
                    ),
                    onTap: () => appState.toggleWorkoutEquipment('Dumbbell'),
                  ),
                  _EquipmentTile(
                    label: 'Bench',
                    active: appState.selectedWorkoutEquipment.contains('Bench'),
                    onTap: () => appState.toggleWorkoutEquipment('Bench'),
                  ),
                  _EquipmentTile(
                    label: 'Kettlebell',
                    active: appState.selectedWorkoutEquipment.contains(
                      'Kettlebell',
                    ),
                    onTap: () => appState.toggleWorkoutEquipment('Kettlebell'),
                  ),
                  _EquipmentTile(
                    label: 'Yoga Mat',
                    active: appState.selectedWorkoutEquipment.contains(
                      'Yoga Mat',
                    ),
                    onTap: () => appState.toggleWorkoutEquipment('Yoga Mat'),
                  ),
                  _EquipmentTile(
                    label: 'Machine',
                    active: appState.selectedWorkoutEquipment.contains(
                      'Machine',
                    ),
                    onTap: () => appState.toggleWorkoutEquipment('Machine'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Quick actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        if (appState.isWorkoutActive) {
                          appState.finishWorkout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Workout finished. Your progress was updated.',
                              ),
                            ),
                          );
                        } else {
                          appState.startWorkout();
                        }
                      },
                      icon: Icon(
                        appState.isWorkoutActive
                            ? Icons.check_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(
                        appState.isWorkoutActive
                            ? 'Finish workout'
                            : 'Start workout',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _open(context, const EquipmentInventoryPage()),
                      icon: const Icon(Icons.inventory_2_outlined),
                      label: const Text('Inventory'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _open(context, const IronPathWorkoutSimulatorProductsPage()),
                icon: const Icon(Icons.storefront_rounded),
                label: const Text('View shop & services'),
                style: FilledButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: _accent,
            foregroundColor: Colors.black,
            onPressed: () => _open(context, const LiveSimulatorPage()),
            icon: const Icon(Icons.fitness_center),
            label: const Text('Simulator'),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index == 1) _open(context, const LiveSimulatorPage());
              if (index == 2) _open(context, const PerformancePage());
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.speed_rounded), label: 'Simulator'),
              NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Progress'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    void open(Widget page) {
      Navigator.pop(context);
      _open(context, page);
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('IronPath Athlete'),
              accountEmail: Text(user?.email ?? 'New athlete'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.fitness_center, color: _accent),
              ),
              decoration: const BoxDecoration(color: Color(0xFF1C1C1E)),
            ),
            ListTile(leading: const Icon(Icons.inventory_2_outlined), title: const Text('Equipment Inventory'), onTap: () => open(const EquipmentInventoryPage())),
            ListTile(leading: const Icon(Icons.speed_outlined), title: const Text('Live Simulator'), onTap: () => open(const LiveSimulatorPage())),
            ListTile(leading: const Icon(Icons.insights_outlined), title: const Text('Performance'), onTap: () => open(const PerformancePage())),
            ListTile(leading: const Icon(Icons.bar_chart_outlined), title: const Text('Statistics'), onTap: () => open(const StatisticsPage())),
            ListTile(leading: const Icon(Icons.directions_run), title: const Text('Activities'), onTap: () => open(const ActivitiesPage())),
            ListTile(leading: const Icon(Icons.emoji_events_outlined), title: const Text('Achievements'), onTap: () => open(const AchievementsPage())),
            ListTile(leading: const Icon(Icons.photo_library_outlined), title: const Text('Gallery'), onTap: () => open(const GalleryPage())),
            ListTile(leading: const Icon(Icons.person_outline), title: const Text('You'), onTap: () => open(const YouPage())),
            ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Settings'), onTap: () => open(const SettingsPage())),
            const Spacer(),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Sign out'), onTap: () => FirebaseAuth.instance.signOut()),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.subValue, required this.color});

  final String label;
  final String value;
  final String subValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171E2A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(subValue, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: '$label focus',
      child: Material(
        color: active ? const Color(0xFFB7FF5A) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: active
                    ? Colors.black
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF0D1117) : const Color(0xFFF4F7F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _EquipmentTile extends StatelessWidget {
  const _EquipmentTile({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      label: '$label equipment',
      child: Material(
        color: active
            ? const Color(0xFFB7FF5A)
            : Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF171E2A)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: active
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: active
                    ? Colors.black
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatElapsed(Duration elapsed) {
  final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
  final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
