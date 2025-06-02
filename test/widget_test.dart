// これは基本的な Flutter ウィジェットテストです。
//
// テスト内でウィジェットを操作するには flutter_test パッケージの
// WidgetTester を使用します。タップやスクロールなどの操作を送ったり、
// 子ウィジェットを検索してテキストを取得したり、プロパティの値を
// 検証したりできます。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testapp/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // アプリを構築してフレームを描画します。
    await tester.pumpWidget(const MyApp());

    // カウンターが 0 から始まることを確認します。
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 「+」アイコンをタップしてフレームを更新します。
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // カウンターが増加したことを確認します。
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
