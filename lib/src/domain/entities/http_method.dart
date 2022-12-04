/// All HTTP methods supported by library
enum HttpMethod {
  get,
  post,
  put,
  patch,
  delete,
}

/// HttpMethod extensions
extension HttpMethodExtension on HttpMethod {
  /// Get a String with the http method
  String get name {
    switch (this) {
      case HttpMethod.get:
        return 'GET';
      case HttpMethod.post:
        return 'POST';
      case HttpMethod.put:
        return 'PUT';
      case HttpMethod.patch:
        return 'PATCH';
      case HttpMethod.delete:
        return 'DELETE';
    }
  }
}
