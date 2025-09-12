import 'package:equatable/equatable.dart';

class ActivitesLogs extends Equatable {
  const ActivitesLogs({
    int? id,
    required String identifier,
    required String status,
    String? lastname,
    String? firstname,
    int? userID,
  })  : _id = id,
        _identifier = identifier,
        _status = status,
        _userID = userID,
        _lastname = lastname,
        _firstname = firstname;
  final int? _id;
  final String _identifier;
  final String _status;
  final int? _userID;
  final String? _lastname;
  final String? _firstname;

  int? get id => _id;
  String get identifier => _identifier;
  String get status => _status;
  int? get userID => _userID;
  String? get lastname => _lastname;
  String? get firstname => _firstname;

  factory ActivitesLogs.fromJson(Map<String, dynamic> json) {
    return ActivitesLogs(
        id: json['id'],
        identifier: json['identifier'],
        status: json['status'],
        userID: json['user_id'],
        lastname: json['lastname'],
        firstname: json['firstname']);
  }

  factory ActivitesLogs.fromMap(Map<String, dynamic> map) {
    return ActivitesLogs(
        id: map['id'],
        identifier: map['identifier'],
        status: map['status'],
        userID: map['userID'],
        lastname: map['lastname'],
        firstname: map['firstname']);
  }

  Map<String, dynamic> toMap() {
    return {"id": _id, "identifier": _identifier, "status": _status, "userID": _userID, "lastname": _lastname, "firstname": _firstname};
  }

  Map<String, dynamic> toJson() {
    return {'identifier': _identifier, 'status': _status, 'user_id': _userID, 'lastname': _lastname, 'firstname': _firstname};
  }

  ActivitesLogs copyWith({
    int? id,
    String? identifier,
    String? status,
    int? userID,
    String? firstname,
    String? lastname,
  }) {
    return ActivitesLogs(
        id: id ?? _id,
        identifier: identifier ?? _identifier,
        status: status ?? _status,
        userID: userID ?? _userID,
        firstname: firstname ?? _firstname,
        lastname: lastname ?? _lastname);
  }

  @override
  List<Object?> get props {
    return [_id, _identifier, _status, _userID, _firstname, _lastname];
  }
}
