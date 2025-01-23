import 'package:equatable/equatable.dart';

class DocumentsModel extends Equatable {
  const DocumentsModel({
    int? id,
    required String identifier,
    required String descriptionDocument,
    required int? typeId,
  })  : _id = id,
        _identifier = identifier,
        _descriptionDocument = descriptionDocument,
        _typeId = typeId;

  final int? _id;
  final String _identifier;
  final String _descriptionDocument;
  final int? _typeId;

  int? get id => _id;
  String get identifier => _identifier;
  String get descriptionDocument => _descriptionDocument;
  int? get typeId => _typeId;

  factory DocumentsModel.fromJson(Map<String, dynamic> json) {
    return DocumentsModel(
      id: json['id'],
      identifier: json['identifier'],
      descriptionDocument: json['description'],
      typeId: json['type_id'],
    );
  }

  factory DocumentsModel.fromMap(Map<String, dynamic> map) {
    return DocumentsModel(
      id: map['id'],
      identifier: map['identifier'],
      descriptionDocument: map['descriptionDocument'],
      typeId: map['typeId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "identifier": _identifier,
      "descriptionDocument": _descriptionDocument,
      "typeId": _typeId,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'identifier': _identifier,
      'description': _descriptionDocument,
      'type_id': _typeId,
    };
  }

  DocumentsModel copyWith({
    int? id,
    String? identifier,
    String? descriptionDocument,
    int? typeId,
  }) {
    return DocumentsModel(
      id: id ?? _id,
      identifier: identifier ?? _identifier,
      descriptionDocument: descriptionDocument ?? _descriptionDocument,
      typeId: typeId ?? _typeId,
    );
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _identifier,
      descriptionDocument,
      typeId,
    ];
  }
}
