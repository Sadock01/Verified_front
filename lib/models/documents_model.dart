import 'package:equatable/equatable.dart';

class DocumentsModel extends Equatable {
  const DocumentsModel({
    int? id,
    required String identifier,
    required String descriptionDocument,
    String? beneficiaire,
    required int? typeId,
    String? typeName,
  })  : _id = id,
        _identifier = identifier,
        _descriptionDocument = descriptionDocument,
        _typeId = typeId,
        _typeName = typeName,
        _beneficiaire = beneficiaire;
  final int? _id;
  final String _identifier;
  final String _descriptionDocument;
  final int? _typeId;
  final String? _typeName;
  final String? _beneficiaire;

  int? get id => _id;
  String get identifier => _identifier;
  String get descriptionDocument => _descriptionDocument;
  int? get typeId => _typeId;
  String? get typeName => _typeName;
  String? get beneficiaire => _beneficiaire;

  factory DocumentsModel.fromJson(Map<String, dynamic> json) {
    return DocumentsModel(
        id: json['id'],
        identifier: json['identifier'],
        descriptionDocument: json['description'],
        typeId: json['type_id'],
        typeName: json['type_name'],
        beneficiaire: json['beneficiaire']);
  }

  factory DocumentsModel.fromMap(Map<String, dynamic> map) {
    return DocumentsModel(
        id: map['id'],
        identifier: map['identifier'],
        descriptionDocument: map['descriptionDocument'],
        typeId: map['typeId'],
        beneficiaire: map[' beneficiaire']);
  }

  Map<String, dynamic> toMap() {
    return {"id": _id, "identifier": _identifier, "descriptionDocument": _descriptionDocument, "typeId": _typeId, "beneficiaire": _beneficiaire};
  }

  Map<String, dynamic> toJson() {
    return {'identifier': _identifier, 'description': _descriptionDocument, 'type_id': _typeId, 'beneficiaire': _beneficiaire};
  }

  DocumentsModel copyWith({
    int? id,
    String? identifier,
    String? descriptionDocument,
    int? typeId,
    String? typeName,
    String? beneficiaire,
  }) {
    return DocumentsModel(
        id: id ?? _id,
        identifier: identifier ?? _identifier,
        descriptionDocument: descriptionDocument ?? _descriptionDocument,
        typeId: typeId ?? _typeId,
        typeName: typeName ?? _typeName,
        beneficiaire: beneficiaire ?? _beneficiaire);
  }

  @override
  List<Object?> get props {
    return [_id, _identifier, descriptionDocument, typeId, _beneficiaire];
  }
}
