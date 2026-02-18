class Env {
  static const Map<String, String> _keys = {
    "ENDPOINT": String.fromEnvironment('ENDPOINT'),
    "PARAMS": String.fromEnvironment('PARAMS'),
    "API_KEY": String.fromEnvironment('API_KEY'),
  };

  static String _getKey(String key) {
    final value = _keys[key] ?? '';
    if (value.isEmpty) {
      throw Exception('$key is not set in Env');
    }
    return value;
  }
  
  static String get apiEndpoint => _getKey('ENDPOINT');
  static String get apiParams => _getKey('PARAMS');
  static String get apiKey => _getKey('API_KEY');
}