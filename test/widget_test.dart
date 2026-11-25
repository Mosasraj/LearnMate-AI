import 'package:flutter_test/flutter_test.dart';
import 'package:learnmate_ai/main.dart';

void main() {
  testWidgets('LearnMate AI launches successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const LearnMateApp());

    expect(find.text('LearnMate AI'), findsOneWidget);
    expect(find.text('Small steps.\nBig possibilities.'), findsOneWidget);
  });
}
