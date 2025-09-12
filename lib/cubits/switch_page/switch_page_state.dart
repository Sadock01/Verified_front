import 'package:equatable/equatable.dart';

class SwitchPageState extends Equatable {
  final double selectedPage;
  final bool isDocumentExpanded;
  final bool isCollabExpanded;

  const SwitchPageState({
    required this.selectedPage,
    this.isDocumentExpanded = false,
    this.isCollabExpanded = false,
  });

  factory SwitchPageState.initial() {
    return const SwitchPageState(
      selectedPage: 0,
    );
  }

  SwitchPageState copyWith({
    double? selectedPage,
    bool? isDocumentExpanded,
    bool? isCollabExpanded,
  }) {
    return SwitchPageState(
        selectedPage: selectedPage ?? this.selectedPage,
        isDocumentExpanded: isDocumentExpanded ?? this.isDocumentExpanded,
        isCollabExpanded: isCollabExpanded ?? this.isCollabExpanded);
  }

  @override
  List<Object> get props => [
        selectedPage,
        isCollabExpanded,
        isDocumentExpanded,
      ];
}
