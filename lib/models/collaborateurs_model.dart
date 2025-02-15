import 'package:equatable/equatable.dart';

class CollaborateursModel extends Equatable {
 const CollaborateursModel({
    int? id,
    required String firstName,
    required String lastName,
    required String email,
    int? status,
    int? roleId,
  })  : _id = id,
        _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _status = status,
        _roleId = roleId;

  final int? _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final int? _status;
  final int? _roleId;

  int? get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  int? get status => _status;
  int? get roleId => _roleId;

  factory CollaborateursModel.fromJson(Map<String, dynamic> json) {
    return CollaborateursModel(
        firstName: json['firstname'],
        lastName: json['lastname'],
        email: json['email'],
        status: json['status'],
        roleId: json['role_id']);
  }

  factory CollaborateursModel.fromMap(Map<String, dynamic> map) {
    return CollaborateursModel(
        firstName: map['firstname'],
        lastName: map['lastname'],
        email: map['email'],
        status: map['status'],
        roleId: map['role_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "status": _status,
      "roleId": _roleId,
    };
  }

  Map<String, dynamic> toJson() {
  return {
    "firstname": _firstName, // Utilisez "firstname" au lieu de "firstName"
    "lastname": _lastName,   // Utilisez "lastname" au lieu de "lastName"
    "email": _email,
    "password": "password", // Ajoutez un mot de passe par défaut
    "role_id": _roleId,            // Utilisez "role_id" au lieu de "roleId"
  };
}

  CollaborateursModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    int? status,
    int? roleId,
  }) {
    return CollaborateursModel(
      firstName: firstName ?? _firstName,
      lastName: lastName ?? _lastName,
      email: email ?? _email,
      status: status ?? _status,
      roleId: roleId ?? roleId,
    );
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _firstName,
      _lastName,
      _email,
      _status,
      _roleId,
    ];
  }
}
