import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_tracker_app/presentation/widgets/welcome_greeting.dart';

void main() {
  testWidgets('Welcome greeting renders expected text', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: WelcomeGreeting(greetingText: 'Welcome, trainee!'),
        ),
      ),
    );

    expect(find.text('Welcome, trainee!'), findsOneWidget);
    expect(find.text('Ready to take your health Seriously?'), findsOneWidget);
  });
}
