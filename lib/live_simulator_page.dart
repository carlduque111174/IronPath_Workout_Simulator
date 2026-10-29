import 'package:flutter/material.dart';

import 'app_state.dart';

class LiveSimulatorPage extends StatefulWidget {
  const LiveSimulatorPage({super.key});

  @override
  State<LiveSimulatorPage> createState() => _LiveSimulatorPageState();
}

class _LiveSimulatorPageState extends State<LiveSimulatorPage> {
  final appState = AppState.instance;
  double _weight = 0;
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    final activity = appState.activities.first;
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Live Simulator')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Train with live feedback', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(activity.status == 'Completed' ? 'Routine complete for today.' : 'Adjust resistance and track your routine as you progress.'),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Icon(Icons.speed, color: Color(0xFFD62828)),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Bodyweight workout simulation', style: TextStyle(fontWeight: FontWeight.bold))),
                    Switch(value: _active, onChanged: (value) => setState(() => _active = value)),
                  ]),
                  const SizedBox(height: 18),
                  Text('${_weight.toStringAsFixed(0)} kg', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                  const Text('Optional added resistance'),
                  Slider(value: _weight, min: 0, max: 200, divisions: 40, label: '${_weight.toStringAsFixed(0)} kg', onChanged: _active ? (value) => setState(() => _weight = value) : null),
                  LinearProgressIndicator(value: _active ? _weight / 200 : 0),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Card(child: ListTile(leading: const Icon(Icons.calculate_outlined), title: const Text('Estimated exercise result'), subtitle: Text('${(_weight * 8).toStringAsFixed(0)} kg training volume'))),
            const SizedBox(height: 20),
            if (activity.status == 'Planned')
              FilledButton.icon(
                onPressed: () => appState.startActivity(activity),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start workout'),
              )
            else if (activity.status == 'In progress')
              FilledButton.icon(
                onPressed: () {
                  appState.completeActivity(activity);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout complete. Your statistics were updated.')));
                },
                icon: const Icon(Icons.check),
                label: const Text('Finish workout'),
              )
            else
              const Card(child: ListTile(leading: Icon(Icons.verified, color: Colors.green), title: Text('Workout completed'), subtitle: Text('Statistics, performance, and achievements are now updated.'))),
          ],
        ),
      ),
    );
  }
}
