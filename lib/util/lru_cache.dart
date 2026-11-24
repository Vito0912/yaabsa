import 'dart:collection';

class LruCache<K, V> extends MapBase<K, V> {
  LruCache({this.maxEntries = 10000}) : assert(maxEntries > 0);

  final int maxEntries;
  final LinkedHashMap<K, V> _entries = LinkedHashMap<K, V>();

  @override
  V? operator [](Object? key) {
    if (!_entries.containsKey(key)) {
      return null;
    }
    final value = _entries.remove(key) as V;
    _entries[key as K] = value;
    return value;
  }

  @override
  void operator []=(K key, V value) {
    _entries.remove(key);
    _entries[key] = value;
    while (_entries.length > maxEntries) {
      _entries.remove(_entries.keys.first);
    }
  }

  @override
  Iterable<K> get keys => _entries.keys;

  @override
  Iterable<V> get values => _entries.values;

  @override
  Iterable<MapEntry<K, V>> get entries => _entries.entries;

  @override
  bool containsKey(Object? key) {
    return _entries.containsKey(key);
  }

  @override
  V? remove(Object? key) {
    return _entries.remove(key);
  }

  @override
  void clear() {
    _entries.clear();
  }
}
