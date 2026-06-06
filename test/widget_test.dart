import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_dio_advanced/app/di/injection_container.dart';
import 'package:flutter_dio_advanced/main.dart';

void main() {
  setUp(() async {
    await sl.reset();
    await setupDependencies();
  });

  testWidgets('API button loads profile and products', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Advanced Dio control room'), findsOneWidget);
    expect(find.text('0 items'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Call APIs'));
    await tester.pumpAndSettle();

    expect(find.text('1 runs'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Force 401 retry'));
    await tester.pumpAndSettle();

    expect(find.text('2 runs'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Load from cache'));
    await tester.pumpAndSettle();

    expect(find.text('Cache allowed'), findsOneWidget);
    expect(find.text('2 runs'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Client policies'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Customization options'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Customization options'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Advanced coverage'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Advanced coverage'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Leanne Graham'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Leanne Graham'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Wireless Headphones'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Wireless Headphones'), findsOneWidget);
    expect(find.text('Mechanical Keyboard'), findsOneWidget);
  });
}
