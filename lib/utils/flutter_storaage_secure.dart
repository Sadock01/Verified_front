// class FlutterStoraageSecure {
//   static const _storage = FlutterSecureStorage();

//   // Clé du token
//   static const String _tokenKey = "user_token";

//   /// Sauvegarde du token
//   static Future<void> saveToken(String token) async {
//     await _storage.write(key: _tokenKey, value: token);
//   }

//   /// Récupération du token
//   static Future<String?> getToken() async {
//     return await _storage.read(key: _tokenKey);
//   }

//   /// Suppression du token (déconnexion)
//   static Future<void> deleteToken() async {
//     await _storage.delete(key: _tokenKey);
//   }
// }