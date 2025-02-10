import 'package:equatable/equatable.dart';

class TypeDocModel extends Equatable {
  const TypeDocModel({
    int? id,
    required String name,
    String? descriptionType,
  })  : _id = id,
        _name = name,
        _descriptionType = descriptionType;

  final int? _id;
  final String _name;
  final String? _descriptionType;

  int? get id => _id;
  String get name => _name;

  factory TypeDocModel.fromJson(Map<String, dynamic> json) {
    return TypeDocModel(
        id: json['id'],
        name: json['name'],
        descriptionType: json['description'] ?? "Description par defaut");
  }

  factory TypeDocModel.fromMap(Map<String, dynamic> map) {
    return TypeDocModel(
        id: map['id'],
        name: map['name'],
        descriptionType: map['descriptionType']);
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "descriptionType": _descriptionType,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      "description": _descriptionType,
    };
  }

  TypeDocModel copyWith({
    int? id,
    String? name,
    String? descriptionType,
  }) {
    return TypeDocModel(
      id: id ?? _id,
      name: name ?? _name,
      descriptionType: descriptionType ?? descriptionType,
    );
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _name,
      _descriptionType,
    ];
  }
}
