import 'package:meta/meta.dart';

@immutable
abstract class Entity {
  const Entity();

  Map<String, dynamic> toJson();
}

@immutable
class Id<E extends Entity> {
  const Id(this.value) : assert(value != null);
  factory Id.orNull(String value) => value == null ? null : Id<E>(value);

  final String value;

  @override
  bool operator ==(dynamic other) => other is Id<E> && other.value == value;
  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
  String toJson() => value;
}
