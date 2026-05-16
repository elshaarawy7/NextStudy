import 'package:flutter_test/flutter_test.dart';
import 'package:nex_study/src/app/nex_study_app.dart';

void main() {
  testWidgets('renders NexStudy branding', (tester) async {
    await tester.pumpWidget(const NexStudyApp());
    expect(find.text('NexStudy'), findsOneWidget);
  });
}
