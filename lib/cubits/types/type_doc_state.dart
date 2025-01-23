
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:equatable/equatable.dart';

enum TypeStatus {
  initial,
  loading,
  loaded,
  error,
}

class TypeDocState extends Equatable {
  final TypeStatus typeStatus;
  final List<TypeDocModel> listType;
  // final int currentPage;
  // final int totalPage;
  final String errorMessage;
  // int? offset;
  // final String? searchKey;
  const TypeDocState({
    required this.typeStatus,
    required this.listType,
    required this.errorMessage,
    // required this.currentPage,
    // required this.totalPage,
    // this.searchKey,
  });

  factory TypeDocState.initial() {
    return TypeDocState(
      typeStatus: TypeStatus.initial,
      listType: [],
      // currentPage: 1,
      // totalPage: 1,
      errorMessage: "",
      
    );
  }

  TypeDocState copyWith({
    TypeStatus? typeStatus,
    List<TypeDocModel>? listType,
    int? currentPage,
    int? totalPage,
    String? errorMessage,
    
    // String? searchKey,
  }) {
    return TypeDocState(
      typeStatus: typeStatus ?? this.typeStatus,
      listType: listType ?? this.listType,
      errorMessage: errorMessage ?? this.errorMessage,
      // currentPage: currentPage ?? this.currentPage,
      // totalPage: totalPage ?? this.totalPage,
      // searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        typeStatus,
        listType,
        // currentPage,
        // totalPage,
        errorMessage,
      ];
}
