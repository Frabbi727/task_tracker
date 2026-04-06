import 'package:json_annotation/json_annotation.dart';

part 'status_response.g.dart';

@JsonSerializable()
class StatusResponse {
  StatusResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  final bool success;
  final String code;
  final String message;
  final StatusData data;

  factory StatusResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusResponseToJson(this);
}

@JsonSerializable()
class StatusData {
  StatusData({required this.statuses});

  final List<String> statuses;

  factory StatusData.fromJson(Map<String, dynamic> json) =>
      _$StatusDataFromJson(json);

  Map<String, dynamic> toJson() => _$StatusDataToJson(this);
}
