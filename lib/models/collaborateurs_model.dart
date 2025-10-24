import 'package:equatable/equatable.dart';

class CollaborateursModel extends Equatable {
  const CollaborateursModel({
    int? id,
    required String firstName,
    required String lastName,
    required String email,
    bool? status,
    int? roleId,
    String? roleName, // nouveau champ
  })  : _id = id,
        _firstName = firstName,
        _lastName = lastName,
        _email = email,
        _status = status,
        _roleId = roleId,
        _roleName = roleName;

  final int? _id;
  final String _firstName;
  final String _lastName;
  final String _email;
  final bool? _status;
  final int? _roleId;
  final String? _roleName; // nouveau champ

  int? get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get email => _email;
  bool? get status => _status;
  int? get roleId => _roleId;
  String? get roleName => _roleName; // getter ajouté

  factory CollaborateursModel.fromJson(Map<String, dynamic> json) {
    return CollaborateursModel(
      id: json['id'],
      firstName: json['firstname'],
      lastName: json['lastname'],
      email: json['email'],
      status: json['status'], // Le backend envoie déjà un booléen
      roleId: json['role_id'],
      roleName: json['role_name'], // récupère le nom du rôle
    );
  }

  factory CollaborateursModel.fromMap(Map<String, dynamic> map) {
    return CollaborateursModel(
      id: map['id'],
      firstName: map['firstname'],
      lastName: map['lastname'],
      email: map['email'],
      status: map['status'], // Le backend envoie déjà un booléen
      roleId: map['role_id'],
      roleName: map['role_name'], // récupère le nom du rôle
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "firstName": _firstName,
      "lastName": _lastName,
      "email": _email,
      "status": _status,
      "roleId": _roleId,
      "roleName": _roleName, // ajoute au map
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "firstname": _firstName,
      "lastname": _lastName,
      "email": _email,
      "password": "password",
      "status": _status,
      "role_id": _roleId,
      "role_name": _roleName, // ajoute au json
    };
  }

  CollaborateursModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    bool? status,
    int? roleId,
    String? roleName, // ajouté
  }) {
    return CollaborateursModel(
      id: id ?? _id,
      firstName: firstName ?? _firstName,
      lastName: lastName ?? _lastName,
      email: email ?? _email,
      status: status ?? _status,
      roleId: roleId ?? _roleId,
      roleName: roleName ?? _roleName,
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
      _roleName,
    ];
  }
}
