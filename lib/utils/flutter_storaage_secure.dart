import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterStorageSecure {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Clé du token
  static const String _tokenKey = "user_token";

  /// Sauvegarde du token
  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      log("Token sauvegardé avec succès");
    } catch (e) {
      log("Erreur lors de l'enregistrement du token: $e");
    }
  }

  /// Récupération du token
  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      log("Erreur lors de la récupération du token: $e");
      return null;
    }
  }

  /// Suppression du token (déconnexion)
  static Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      log("Erreur lors de la suppression du token: $e");
    }
  }
}
