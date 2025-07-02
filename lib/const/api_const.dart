import 'package:dio/dio.dart';

class ApiConfig {
  static api() {
    final options = BaseOptions(
      baseUrl: 'https://7b08-137-255-82-33.ngrok-free.app/api/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        // On accepte tous les statuts et on gère nous-mêmes les erreurs.
        return status! < 600;
      },
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true'
      },
    );

    return Dio(options);
  }
}
