import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:ironpath_workout_simulator/ironpath_workout_simulator_products_page.dart';

void main() {
  testWidgets('catalog fetches API products and filters search results', (
    tester,
  ) async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(
        jsonEncode([
          {
            'id': 101,
            'title': 'Compact Rowing Machine',
            'category': 'fitness equipment',
            'price': 249.99,
            'rating': {'rate': 4.7},
            'description': 'A full-body cardio training machine.',
            'image': 'https://example.com/rowing-machine.png',
          },
          {
            'id': 102,
            'title': 'Yoga Mat',
            'category': 'fitness equipment',
            'price': 29.99,
            'rating': {'rate': 4.4},
            'description': 'A cushioned mat for stretching.',
            'image': 'https://example.com/yoga-mat.png',
          },
        ]),
        200,
      );
    });

    await tester.pumpWidget(
      MaterialApp(home: IronPathWorkoutSimulatorProductsPage(client: client)),
    );
    await tester.pumpAndSettle();

    expect(requests, hasLength(1));
    expect(requests.single.method, 'GET');
    expect(requests.single.url.path, '/products');

    await tester.enterText(find.byType(TextField), 'rowing');
    await tester.pumpAndSettle();

    expect(find.text('Compact Rowing Machine'), findsOneWidget);
    expect(find.text('Yoga Mat'), findsNothing);
    expect(find.text('IronPath Strength Kit'), findsNothing);

    await tester.enterText(find.byType(TextField), 'full-body cardio');
    await tester.pumpAndSettle();

    expect(find.text('Compact Rowing Machine'), findsOneWidget);
    expect(find.text('Yoga Mat'), findsNothing);

    client.close();
  });
}
