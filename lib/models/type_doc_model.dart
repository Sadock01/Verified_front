import 'package:equatable/equatable.dart';

class TypeDocModel extends Equatable {
  const TypeDocModel({
    int? id,
    required String name,
    String? descriptionType,
    DateTime? createdAt, // Nouvel attribut
  })  : _id = id,
        _name = name,
        _descriptionType = descriptionType,
        _createdAt = createdAt;

  final int? _id;
  final String _name;
  final String? _descriptionType;
  final DateTime? _createdAt; // Date de création

  int? get id => _id;
  String get name => _name;
  DateTime? get createdAt => _createdAt; // Getter pour createdAt

  factory TypeDocModel.fromJson(Map<String, dynamic> json) {
    return TypeDocModel(
      id: json['id'],
      name: json['name'],
      descriptionType: json['description'] ?? "Description par défaut",
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']) // Convertir la chaîne de caractères en DateTime
          : null,
    );
  }

  factory TypeDocModel.fromMap(Map<String, dynamic> map) {
    return TypeDocModel(
      id: map['id'],
      name: map['name'],
      descriptionType: map['descriptionType'],
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at']) // Conversion en DateTime
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": _name,
      "descriptionType": _descriptionType,
      "createdAt": _createdAt?.toIso8601String(), // Format ISO 8601 pour la date
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      "description": _descriptionType,
      'createdAt': _createdAt?.toIso8601String(), // Format ISO 8601 pour la date
    };
  }

  TypeDocModel copyWith({
    int? id,
    String? name,
    String? descriptionType,
    DateTime? createdAt,
  }) {
    return TypeDocModel(
      id: id ?? _id,
      name: name ?? _name,
      descriptionType: descriptionType ?? _descriptionType,
      createdAt: createdAt ?? _createdAt, // Copie de createdAt
    );
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _name,
      _descriptionType,
      _createdAt, // Ajout de createdAt pour l'égalité
    ];
  }
}
