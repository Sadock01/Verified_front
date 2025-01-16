import 'package:dio/dio.dart';

class ApiConfig {
  static api() {
    final options = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000',
      // baseUrl: 'https://api.odysseedessens.dedpos.mainfo.biz/api/v1/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        // On accepte tous les statuts et on gère nous-mêmes les erreurs.
        return status! < 600;
      },
    );

    return Dio(options);
  }
}