import 'package:dio/dio.dart';

class ApiConfig {
  static api() {
    final options = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        // On accepte tous les statuts et on gère nous-mêmes les erreurs.
        return status! < 600;
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    return Dio(options);
  }
}
