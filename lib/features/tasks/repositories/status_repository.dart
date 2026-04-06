import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_endpoints.dart';
import '../models/status_response.dart';

class StatusRepository {
  StatusRepository(this._dio);

  final Dio _dio;

  Future<List<String>> fetchStatuses() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.statusList,
    );
    final payload = response.data ?? <String, dynamic>{};
    debugPrint('Status API response: $payload');
    final statusResponse = StatusResponse.fromJson(payload);
    return statusResponse.data.statuses;
  }
}
