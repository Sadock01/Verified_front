import 'package:equatable/equatable.dart';

class DocumentsModel extends Equatable {
  const DocumentsModel({
    int? id,
    required String identifier,
    required String descriptionDocument,
    String? beneficiaire,
    String? dateInfo,
    int? typeId,
    String? typeName,
  })  : _id = id,
        _identifier = identifier,
        _descriptionDocument = descriptionDocument,
        _typeId = typeId,
        _typeName = typeName,
        _beneficiaire = beneficiaire,
  _dateInfo = dateInfo;
  final int? _id;
  final String _identifier;
  final String _descriptionDocument;
  final int? _typeId;
  final String? _typeName;
  final String? _beneficiaire;
  final String? _dateInfo;

  int? get id => _id;
  String get identifier => _identifier;
  String get descriptionDocument => _descriptionDocument;
  int? get typeId => _typeId;
  String? get typeName => _typeName;
  String? get beneficiaire => _beneficiaire;
  String? get dateInfo => _dateInfo;

  factory DocumentsModel.fromJson(Map<String, dynamic> json) {
    return DocumentsModel(
        id: json['id'],
        identifier: json['identifier'],
        descriptionDocument: json['description'],
        typeId: json['type_id'],
        typeName: json['type_name'],
        beneficiaire: json['beneficiaire'],
    dateInfo: json['date_information']);
  }

  factory DocumentsModel.fromMap(Map<String, dynamic> map) {
    return DocumentsModel(
        id: map['id'],
        identifier: map['identifier'],
        descriptionDocument: map['description'],
        typeId: map['typeId'],
        typeName: map['type_name'],
        beneficiaire: map['beneficiaire'],
    dateInfo: map['date_information']);
  }

  Map<String, dynamic> toMap() {
    return {"id": _id, "identifier": _identifier, "description": _descriptionDocument, "typeId": _typeId, "beneficiaire": _beneficiaire, "dateInfo": _dateInfo};
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': _identifier,
      'description': _descriptionDocument,
      'type_id': _typeId,
      'type_name': _typeName,
      'beneficiaire': _beneficiaire,
      'date_information': _dateInfo
    };
  }

  DocumentsModel copyWith({
    int? id,
    String? identifier,
    String? descriptionDocument,
    int? typeId,
    String? typeName,
    String? beneficiaire,
    String? dateInfo,
  }) {
    return DocumentsModel(
        id: id ?? _id,
        identifier: identifier ?? _identifier,
        descriptionDocument: descriptionDocument ?? _descriptionDocument,
        typeId: typeId ?? _typeId,
        typeName: typeName ?? _typeName,
        beneficiaire: beneficiaire ?? _beneficiaire,
    dateInfo: dateInfo ?? _dateInfo);
  }

  @override
  List<Object?> get props {
    return [_id, _identifier, descriptionDocument, typeId, _beneficiaire,dateInfo];
  }
}
