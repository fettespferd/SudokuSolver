import 'package:sudokuSolver/app/module.dart';
import 'package:test/test.dart';

typedef JsonDeserializer<T> = T Function(Map<String, dynamic> json);

@isTestGroup
void testJsonSerialization<T>(
  String description, {
  @required T object,
  @required Map<String, dynamic> json,
  @required JsonDeserializer<T> fromJson,
}) {
  assert(object != null);
  assert(json != null);

  group(description, () {
    test('toJson()', () => expect((object as dynamic).toJson(), json));
    test('fromJson()', () => expect(fromJson(json), object));
  });
}
