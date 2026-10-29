import 'package:flutter/material.dart';

import 'app_state.dart';
import 'additional_pages.dart';

class PerformancePage extends StatelessWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Performance')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Your progress', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(state.hasProgress ? 'Your completed routines are building your record.' : 'No progress yet. Finish your first workout to see results.'),
            const SizedBox(height: 20),
            Row(children: [_metricCard(context, '${state.completedWorkouts}', 'Sessions'), const SizedBox(width: 12), _metricCard(context, '${state.activeMinutes}', 'Minutes')]),
            const SizedBox(height: 12),
            Row(children: [_metricCard(context, state.trainingVolume.toStringAsFixed(0), 'Volume kg'), const SizedBox(width: 12), _metricCard(context, state.hasProgress ? '1' : '0', 'Streak days')]),
            const SizedBox(height: 20),
            Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Weekly training load', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: state.hasProgress ? 0.2 : 0, minHeight: 10),
              const SizedBox(height: 10),
              Text(state.hasProgress ? 'First workout recorded' : '0% complete', style: TextStyle(color: Colors.grey.shade700)),
            ]))),
            const SizedBox(height: 20),
            Text('Achievements', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AchievementTile(title: 'First session', detail: 'Complete your first workout.', unlocked: state.completedWorkouts >= 1),
            AchievementTile(title: 'Seven-day streak', detail: 'Train seven days in a row.', unlocked: false),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(BuildContext context, String value, String label) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Colors.grey.shade700)),
            ],
          ),
        ),
      ),
    );
  }
}
