import 'package:equatable/equatable.dart';

class VerificationModel extends Equatable {
  final int? _id;
  final String _identifier;
  final DateTime _verificationDate;
  final String _status; // 'Authentique' or 'Frauduleux'

  const VerificationModel({
    int? id,
    required String identifier,
    required DateTime verificationDate,
    required String status,
  })  : _id = id,
        _identifier = identifier,
        _verificationDate = verificationDate,
        _status = status;

  int? get id => _id;
  String get identifier => _identifier;
  DateTime get verificationDate => _verificationDate;
  String get status => _status;

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    return VerificationModel(
      id: json['id'],
      identifier: json['identifier'],
      verificationDate: DateTime.parse(json['verification_date']),
      status: json['status'],
    );
  }

  factory VerificationModel.fromMap(Map<String, dynamic> map) {
    return VerificationModel(
      id: map['id'],
      identifier: map['identifier'],
      verificationDate: DateTime.parse(map['verification_date']),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "identifier": _identifier,
      "verification_date": _verificationDate.toIso8601String(),
      "status": _status,
    };
  }

  VerificationModel copyWith({
    int? id,
    String? identifier,
    DateTime? verificationDate,
    String? status,
  }) {
    return VerificationModel(
      id: id ?? _id,
      identifier: identifier ?? _identifier,
      verificationDate: verificationDate ?? _verificationDate,
      status: status ?? _status,
    );
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _identifier,
      _verificationDate,
      _status,
    ];
  }
}
