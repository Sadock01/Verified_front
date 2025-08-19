import 'package:doc_authentificator/models/collaborateurs_model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ReportModel extends Equatable {
  final String firstName;
  final String lastName;
  final int userId;
  final DateTime modifiedAt;
  final List<ChangeModel> changes;
  final CollaborateursModel user;

  const ReportModel({
    required this.firstName,
    required this.lastName,
    required this.modifiedAt,
    required this.userId,
    required this.changes,
    required this.user,
  });

  String get formattedDate {
    return DateFormat('dd/MM/yyyy HH:mm').format(modifiedAt!);
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      firstName: json['user']['firstname'],
      lastName: json['user']['lastname'],
      modifiedAt: DateTime.parse(json['modified_at']),
      userId: json['user_id'] ?? 1,
      // changes: (json['changes'] as Map<String, dynamic>).entries.map((entry) {
      //   return ChangeModel(
      //     field: entry.key,
      //     oldValue: entry.value['old'].toString(),
      //     newValue: entry.value['new'].toString(),
      //   );
      // }).toList(),
      changes: () {
        final changesData = json['changes'];
        if (changesData is Map<String, dynamic>) {
          return changesData.entries.map((entry) {
            return ChangeModel(
              field: entry.key,
              oldValue: entry.value['old'].toString(),
              newValue: entry.value['new'].toString(),
            );
          }).toList();
        } else if (changesData is List && changesData.isEmpty) {
          // changes est une liste vide => pas de changements
          return <ChangeModel>[];
        } else {
          // Cas inattendu, retourne une liste vide par défaut
          return <ChangeModel>[];
        }
      }(),
      user: CollaborateursModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "modified_at": modifiedAt.toIso8601String(),
      "changes": changes.map((c) => c.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [firstName, lastName, modifiedAt, changes];
}

class ChangeModel extends Equatable {
  final String field;
  final String oldValue;
  final String newValue;

  const ChangeModel({
    required this.field,
    required this.oldValue,
    required this.newValue,
  });

  factory ChangeModel.fromJson(Map<String, dynamic> json) {
    return ChangeModel(
      field: json['field'],
      oldValue: json['old_value'].toString(),
      newValue: json['new_value'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "field": field,
      "old_value": oldValue,
      "new_value": newValue,
    };
  }

  @override
  List<Object?> get props => [field, oldValue, newValue];
}
