import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_testing_demo4/todo_list.dart';

class TestContextWidget extends StatelessWidget {
  final Widget child;

  TestContextWidget({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      ),
    );
  }
}

void main() {
  group('Adding items to the list', () {
    testWidgets('Look at place to add a Todo', (WidgetTester tester) async {
      await tester.pumpWidget(TestContextWidget(child: TodoList()));

      var textfield = find.byType(TextField);

      expect(textfield, findsOneWidget);
    });

    testWidgets('Enter text in the Todo', (WidgetTester tester) async {
      await tester.pumpWidget(TestContextWidget(child: TodoList()));

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'hi');
      await tester.pump();

      //Finds text in the Texfield widget
      expect(find.text('hi'), findsOneWidget);
    });

    testWidgets('Add an item in the Todo', (WidgetTester tester) async {
      await tester.pumpWidget(TestContextWidget(child: TodoList()));

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'hi');
      await tester.pump();

      //Add the item in the list
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      var widget = find.ancestor(
        of: find.text('hi'),
        matching: find.byKey(Key('hi0')),
      );
      expect(widget, findsOneWidget);
    });

    testWidgets('Add two items in the list', (WidgetTester tester) async {
      await tester.pumpWidget(TestContextWidget(child: TodoList()));

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      //Add the item in the list
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'world');
      await tester.pump();

      //Add the item in the list
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      var item1 = find.ancestor(
        of: find.text('hello'),
        matching: find.byKey(Key('hello0')),
      );
      expect(item1, findsOneWidget);

      var item2 = find.ancestor(
        of: find.text('world'),
        matching: find.byKey(Key('world1')),
      );
      expect(item2, findsOneWidget);
    });
  });

  group('Deleting items in a list', () {
    testWidgets('Swipe to dismiss one item', (WidgetTester tester) async {
      await tester.pumpWidget(TestContextWidget(child: TodoList()));

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      //Add the item in the list
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      // Enter 'hello' into the TextField.
      await tester.enterText(find.byType(TextField), 'world');
      await tester.pump();

      //Add the item in the list
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      await tester.drag(find.byKey(Key('hello0')), Offset(500.0, 0.0));

      await tester.pumpAndSettle();

      // Enter 'hello' again into the TextField. => Check if Dismissible updates model
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.text('hello'), findsNothing);
      //20 => tests passes but Runtime error found with Dismissible
      // reason is: a Dismissible widget is still part of the tree
      //need to implement onDismissed handler to clean model
    });
  });
}
