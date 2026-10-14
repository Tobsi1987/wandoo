import 'dart:async';

/// Ein Wert nur im Speicher, der jede Änderung meldet. Grundlage der
/// `InMemory…Repository`-Klassen für Tests und die Demo.
class MemoryValue<T> {
  MemoryValue(T value) : _value = value;

  T _value;
  final _changes = StreamController<T>.broadcast();

  /// Der Wert sofort, ohne zu warten.
  T get current => _value;

  Future<T> load() async => _value;

  Future<void> save(T value) async => _changes.add(_value = value);

  /// Erst der jetzige Wert, dann jede Änderung.
  Stream<T> watch() async* {
    yield _value;
    yield* _changes.stream;
  }
}
