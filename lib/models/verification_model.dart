import 'package:equatable/equatable.dart';

class VerificationModel extends Equatable {
  final int? _id;
  final String? _identifier;
  final DateTime _createdAt;
  final String _status; // 'Authentique' or 'Frauduleux'

  // Nouveaux champs ajoutés
  final String? _ipAddress;
  final String? _userAgent;
  final String? _browser;
  final String? _deviceType;
  final String? _platform;
  final bool _viaFile;
  final bool _documentFound;
  final bool _isMatching;
  final Map<String, dynamic>? _enteredData;
  final Map<String, dynamic>? _extractedData;
  final Map<String, dynamic>? _mismatches;

  const VerificationModel({
    int? id,
    String? identifier,
    required DateTime createdAt,
    required String status,
    String? ipAddress,
    String? userAgent,
    String? browser,
    String? deviceType,
    String? platform,
    required bool viaFile,
    required bool documentFound,
    required bool isMatching,
    Map<String, dynamic>? enteredData,
    Map<String, dynamic>? extractedData,
    Map<String, dynamic>? mismatches,
  })  : _id = id,
        _identifier = identifier,
        _createdAt = createdAt,
        _status = status,
        _ipAddress = ipAddress,
        _userAgent = userAgent,
        _browser = browser,
        _deviceType = deviceType,
        _platform = platform,
        _viaFile = viaFile,
        _documentFound = documentFound,
        _isMatching = isMatching,
        _enteredData = enteredData,
        _extractedData = extractedData,
        _mismatches = mismatches;

  int? get id => _id;
  String? get identifier => _identifier;
  DateTime get createdAt => _createdAt;
  String get status => _status;
  String? get ipAddress => _ipAddress;
  String? get userAgent => _userAgent;
  String? get browser => _browser;
  String? get deviceType => _deviceType;
  String? get platform => _platform;
  bool get viaFile => _viaFile;
  bool get documentFound => _documentFound;
  bool get isMatching => _isMatching;
  Map<String, dynamic>? get enteredData => _enteredData;
  Map<String, dynamic>? get extractedData => _extractedData;
  Map<String, dynamic>? get mismatches => _mismatches;

  factory VerificationModel.fromJson(Map<String, dynamic> json) {
    // Identifier avec gestion de la valeur nulle
    String? identifier = json['entered_data']?['identifier'];

    // Si identifier est null, on attribue une valeur par défaut
    if (identifier == null || identifier.isEmpty) {
      identifier = 'Non renseigné';
    }

    // Définir un message de status plus parlant
    String status = json['is_matching'] != null && json['is_matching']
        ? 'Information correspondante'
        : 'Information erronée';

    // Messages de 'documentFound'
    bool documentFound = json['document_found'] ?? false;

    return VerificationModel(
      id: json['id'],
      identifier: identifier,
      createdAt: DateTime.parse(json['created_at']),
      status: status,
      ipAddress: json['ip_address'],
      userAgent: json['user_agent'],
      browser: json['browser'],
      deviceType: json['device_type'],
      platform: json['platform'],
      viaFile: json['via_file'] ?? false,
      documentFound: documentFound,
      isMatching: json['is_matching'] ?? false,
      enteredData: json['entered_data'] != null
          ? Map<String, dynamic>.from(json['entered_data'])
          : null,
      extractedData: json['extracted_data'] != null
          ? Map<String, dynamic>.from(json['extracted_data'])
          : null,
      mismatches: json['mismatches'] != null
          ? Map<String, dynamic>.from(json['mismatches'])
          : null,
    );
  }

  factory VerificationModel.fromMap(Map<String, dynamic> map) {
    return VerificationModel(
      id: map['id'],
      identifier: map['entered_data']['identifier'],
      createdAt: DateTime.parse(map['created_at']),
      status: map['is_matching'] != null && map['is_matching']
          ? 'Information correspondante'
          : 'Information erronée',
      ipAddress: map['ip_address'],
      userAgent: map['user_agent'],
      browser: map['browser'],
      deviceType: map['device_type'],
      platform: map['platform'],
      viaFile: map['via_file'] ?? false,
      documentFound: map['document_found'] ?? false,
      isMatching: map['is_matching'] ?? false,
      enteredData: map['entered_data'] != null
          ? Map<String, dynamic>.from(map['entered_data'])
          : null,
      extractedData: map['extracted_data'] != null
          ? Map<String, dynamic>.from(map['extracted_data'])
          : null,
      mismatches: map['mismatches'] != null
          ? Map<String, dynamic>.from(map['mismatches'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": _id,
      "identifier": _identifier,
      "created_at": _createdAt.toIso8601String(),
      "status": _status,
      "ip_address": _ipAddress,
      "user_agent": _userAgent,
      "browser": _browser,
      "device_type": _deviceType,
      "platform": _platform,
      "via_file": _viaFile,
      "document_found": _documentFound,
      "is_matching": _isMatching,
      "entered_data": _enteredData,
      "extracted_data": _extractedData,
      "mismatches": _mismatches,
    };
  }

  @override
  List<Object?> get props {
    return [
      _id,
      _identifier,
      _createdAt,
      _status,
      _ipAddress,
      _userAgent,
      _browser,
      _deviceType,
      _platform,
      _viaFile,
      _documentFound,
      _isMatching,
      _enteredData,
      _extractedData,
      _mismatches,
    ];
  }
}
