import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: MyApp()));
    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    // Tap the ‘+’ icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    // Verify that our counter has incremented to 1.
    expect(find.text('1'), findsOneWidget);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            counter.toString(),
            style: TextStyle(fontSize: 24),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: incrementCounter,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
