/// Model to save the data in database
class SyncDataEntity {
  SyncDataEntity({
    required this.data,
    required this.path,
    required this.method,
    this.queryParameters,
  });

  final dynamic data;
  final String path;
  final String method;
  Map<String, dynamic>? queryParameters;

  factory SyncDataEntity.fromJson(Map<String, dynamic> json) => SyncDataEntity(
        path: json['path'],
        data: json['data'],
        method: json['method'],
        queryParameters: json['queryParameters'],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "data": data,
        "method": method,
        "queryParameters": queryParameters,
      };
}
