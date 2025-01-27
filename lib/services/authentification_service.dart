// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:doc_authentificator/const/api_const.dart';
// import 'package:doc_authentificator/utils/flutter_storaage_secure.dart';

// class AuthentificationService {
//   static Dio api = ApiConfig.api();
//   static Future<void> login(String email, String password) async {
//     final response = await api.post("login", data: {
//       "email": email,
//       "password": password,
//     });
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       String token = response.data['token'];
//       log("Connexion réussie : $token");
//       await FlutterStoraageSecure.saveToken(token);
//       return response.data['message'];
//     } else {
//       throw Exception(response.data['message'] ??
//           "Une erreur est survenue lors de la connexion");
//     }
//   }

//   static Future<String> logout() async {
//     api.options.headers['AUTHORIZATION'] =
//         'Bearer ${FlutterStoraageSecure.getToken()}';
//     final response = await api.post("logout");
//     log('il se trouve ici');
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       FlutterStoraageSecure.logout();
//       return response.data['message'];
//     } else {
//       throw Exception("Echec de connexion");
//     }

    
//   }

  
// }
