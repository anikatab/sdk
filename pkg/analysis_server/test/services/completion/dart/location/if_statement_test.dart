// Copyright (c) 2023, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:analysis_server/src/protocol_server.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../../../../client/completion_driver_test.dart';
import '../completion_printer.dart' as printer;

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(IfStatementTest1);
    defineReflectiveTests(IfStatementTest2);
  });
}

@reflectiveTest
class IfStatementTest1 extends AbstractCompletionDriverTest
    with IfStatementTestCases {
  @override
  TestingCompletionProtocol get protocol => TestingCompletionProtocol.version1;
}

@reflectiveTest
class IfStatementTest2 extends AbstractCompletionDriverTest
    with IfStatementTestCases {
  @override
  TestingCompletionProtocol get protocol => TestingCompletionProtocol.version2;
}

mixin IfStatementTestCases on AbstractCompletionDriverTest {
  @override
  Future<void> setUp() async {
    await super.setUp();

    // TODO(brianwilkerson) Include more than keywords in these tests.
    printerConfiguration = printer.Configuration(
      filter: (suggestion) {
        return suggestion.kind == CompletionSuggestionKind.KEYWORD;
      },
    );
  }

  Future<void> test_rightParen_withCondition_withoutCase() async {
    await computeSuggestions('''
void f(Object o) {
  if (o ^) {}
}
''');
    assertResponse('''
suggestions
  case
    kind: keyword
  is
    kind: keyword
''');
  }

  Future<void> test_rightParen_withoutCondition() async {
    await computeSuggestions('''
void f() {
  if (^) {}
}
''');
    assertResponse('''
suggestions
  false
    kind: keyword
  true
    kind: keyword
  null
    kind: keyword
  const
    kind: keyword
  switch
    kind: keyword
''');
  }
}
