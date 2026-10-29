import 'package:flutter/material.dart';

import 'app_state.dart';

class EquipmentInventoryPage extends StatefulWidget {
  const EquipmentInventoryPage({super.key});

  @override
  State<EquipmentInventoryPage> createState() => _EquipmentInventoryPageState();
}

class _EquipmentInventoryPageState extends State<EquipmentInventoryPage> {
  final appState = AppState.instance;

  Future<void> _addEquipment() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController(text: 'Dumbbell');
    final weightController = TextEditingController(text: '0');
    final exerciseController = TextEditingController(text: 'General training');

    final result = await showDialog<Equipment>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add equipment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: typeController, decoration: const InputDecoration(labelText: 'Type')),
              TextField(controller: weightController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Loaded weight (kg)')),
              TextField(controller: exerciseController, decoration: const InputDecoration(labelText: 'Exercise usage')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              final weight = double.tryParse(weightController.text.trim());
              if (name.isEmpty || weight == null || weight < 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a name and valid weight')));
                return;
              }
              Navigator.pop(
                dialogContext,
                Equipment(
                  name: name,
                  type: typeController.text.trim().isEmpty ? 'Equipment' : typeController.text.trim(),
                  weight: weight,
                  exercise: exerciseController.text.trim().isEmpty ? 'General training' : exerciseController.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameController.dispose();
    typeController.dispose();
    weightController.dispose();
    exerciseController.dispose();
    if (result != null) appState.addEquipment(result);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Equipment Inventory')),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Equipment for your workouts', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Start with bodyweight training, then add equipment when you have it.'),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.accessibility_new),
                title: Text('No Equipment'),
                subtitle: Text('Body Weight workout is always available.'),
                trailing: Icon(Icons.check_circle_outline),
              ),
            ),
            const SizedBox(height: 16),
            Text('With Equipment', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (appState.equipment.isEmpty)
              const Card(child: ListTile(title: Text('No equipment added'), subtitle: Text('Add a barbell, dumbbell, lat cable, or pull-up bar.'))),
            ...appState.equipment.map(
              (item) => Card(
                child: ListTile(
                  leading: const Icon(Icons.fitness_center, color: Color(0xFFD62828)),
                  title: Text(item.name),
                  subtitle: Text('${item.type}  •  ${item.weight.toStringAsFixed(1)} kg\nUsed for ${item.exercise}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    tooltip: 'Delete equipment',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => appState.removeEquipment(item),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _addEquipment,
          icon: const Icon(Icons.add),
          label: const Text('Add equipment'),
        ),
      ),
    );
  }
}
