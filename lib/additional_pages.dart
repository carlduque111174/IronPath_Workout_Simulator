import 'package:flutter/material.dart';

import 'app_state.dart';
import 'main.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => SimplePage(
        title: 'Statistics',
        icon: Icons.bar_chart,
        intro: state.hasProgress
            ? 'Your completed workout data.'
            : 'Complete your first workout to start collecting data.',
        children: [
          StatTile(
            label: 'Total sessions',
            value: '${state.completedWorkouts}',
            icon: Icons.fitness_center,
          ),
          StatTile(
            label: 'Training volume',
            value: '${state.trainingVolume.toStringAsFixed(0)} kg',
            icon: Icons.monitor_weight_outlined,
          ),
          StatTile(
            label: 'Active minutes',
            value: '${state.activeMinutes}',
            icon: Icons.timer_outlined,
          ),
          StatTile(
            label: 'Current streak',
            value: state.hasProgress ? '1 day' : '0 days',
            icon: Icons.local_fire_department,
          ),
        ],
      ),
    );
  }
}

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final today = DateTime.now().weekday;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Activities')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Your workout routine',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Each day targets different muscles, followed by recovery days.',
            ),
            const SizedBox(height: 20),
            ...state.activities.map(
              (activity) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: activity.isRestDay
                        ? Colors.grey.shade200
                        : activity.status == 'Completed'
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      activity.isRestDay
                          ? Icons.hotel_outlined
                          : activity.status == 'Completed'
                          ? Icons.check
                          : Icons.fitness_center,
                    ),
                  ),
                  title: Text('${activity.day}: ${activity.name}'),
                  subtitle: Text(
                    activity.isRestDay
                        ? 'Recovery day'
                        : '${activity.focus}  •  ${activity.status == 'In progress' ? 'Progressing now' : activity.status}',
                  ),
                  trailing: activity.isRestDay || activity.status == 'Completed'
                      ? const Icon(Icons.verified, color: Colors.green)
                      : FilledButton(
                          onPressed: () {
                            if (activity.status == 'Planned') {
                              state.startActivity(activity);
                            } else {
                              state.completeActivity(activity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Workout finished. Progress updated.',
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            activity.status == 'Planned' ? 'Start' : 'Finish',
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.red.shade50,
              child: ListTile(
                leading: const Icon(Icons.today, color: Colors.red),
                title: Text('Today: ${state.activities[today - 1].name}'),
                subtitle: Text(
                  state.activities[today - 1].isRestDay
                      ? 'Take time to recover and come back stronger.'
                      : 'Today\'s focus: ${state.activities[today - 1].focus}',
                ),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                state.addActivity('New bodyweight routine');
              },
              icon: const Icon(Icons.add),
              label: const Text('Add activity'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  bool _sound = true;

  @override
  Widget build(BuildContext context) {
    final selectedTheme = AppThemeController.instance.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Preferences',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Theme'),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        label: Text('Light mode'),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        label: Text('Dark Mode'),
                      ),
                    ],
                    selected: {selectedTheme},
                    onSelectionChanged: (newSelection) {
                      final themeMode = newSelection.first;
                      AppThemeController.instance.setThemeMode(themeMode);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Workout reminders'),
                  value: _notifications,
                  onChanged: (value) => setState(() => _notifications = value),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Training sounds'),
                  value: _sound,
                  onChanged: (value) => setState(() => _sound = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class YouPage extends StatelessWidget {
  const YouPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => SimplePage(
        title: 'You',
        icon: Icons.person_outline,
        intro: 'Your IronPath athlete profile.',
        children: [
          ProfileTile(
            label: 'Training level',
            value: state.hasProgress ? 'Getting stronger' : 'New athlete',
          ),
          ProfileTile(label: 'Favorite focus', value: 'Full body'),
          ProfileTile(
            label: 'Completed workouts',
            value: '${state.completedWorkouts}',
          ),
        ],
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Gallery')),
    body: GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: const [
        GalleryTile(title: 'Workout photos', icon: Icons.photo_camera_outlined),
        GalleryTile(title: 'Progress check', icon: Icons.insights_outlined),
        GalleryTile(title: 'Performance', icon: Icons.fitness_center),
        GalleryTile(title: 'Personal bests', icon: Icons.emoji_events_outlined),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Add a performance picture after a workout.'),
          ),
        );
      },
      tooltip: 'Add performance picture',
      child: const Icon(Icons.add_a_photo),
    ),
  );
}

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => SimplePage(
        title: 'Achievements',
        icon: Icons.emoji_events_outlined,
        intro: state.hasProgress
            ? 'Milestones earned from your training.'
            : 'Complete a workout to earn your first badge.',
        children: [
          AchievementTile(
            title: 'First session',
            detail: 'Complete your first workout.',
            unlocked: state.completedWorkouts >= 1,
          ),
          AchievementTile(
            title: 'Seven-day streak',
            detail: 'Train seven days in a row.',
            unlocked: false,
          ),
          AchievementTile(
            title: 'Volume builder',
            detail: 'Reach 10,000 kg total volume.',
            unlocked: state.trainingVolume >= 10000,
          ),
        ],
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({
    required this.title,
    required this.icon,
    required this.intro,
    required this.children,
    super.key,
  });
  final String title;
  final IconData icon;
  final String intro;
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(intro),
        const SizedBox(height: 20),
        ...children,
      ],
    ),
  );
}

class StatTile extends StatelessWidget {
  const StatTile({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });
  final String label;
  final String value;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
  );
}

class ProfileTile extends StatelessWidget {
  const ProfileTile({required this.label, required this.value, super.key});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(title: Text(label), subtitle: Text(value)),
  );
}

class GalleryTile extends StatelessWidget {
  const GalleryTile({required this.title, required this.icon, super.key});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a picture after completing a workout.'),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 42),
          const SizedBox(height: 12),
          Text(title),
        ],
      ),
    ),
  );
}

class AchievementTile extends StatelessWidget {
  const AchievementTile({
    required this.title,
    required this.detail,
    required this.unlocked,
    super.key,
  });
  final String title;
  final String detail;
  final bool unlocked;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: CircleAvatar(
        child: Icon(unlocked ? Icons.check : Icons.lock_outline),
      ),
      title: Text(title),
      subtitle: Text(detail),
      trailing: Text(unlocked ? 'Earned' : 'Locked'),
    ),
  );
}
