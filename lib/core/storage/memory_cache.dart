/// Small in-memory cache used by the demo.
///
/// A real Flutter app could replace this with Isar, Hive, SQLite, or
/// SharedPreferences depending on the size and shape of the data.
class MemoryCache {
  final Map<String, Object> _values = {};

  T? read<T extends Object>(String key) => _values[key] as T?;

  void write<T extends Object>(String key, T value) {
    _values[key] = value;
  }

  void clear(String key) {
    _values.remove(key);
  }
}
