
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:equatable/equatable.dart';

enum TypeStatus {
  initial,
  loading,
  loaded,
  sucess,
  error,
}

class TypeDocState extends Equatable {
  final TypeStatus typeStatus;
  final List<TypeDocModel> listType;
  final int currentPage;
  final int totalPage;
  final String errorMessage;
  final TypeDocModel? selectedtype;
  // int? offset;
  // final String? searchKey;
  const TypeDocState({
    required this.typeStatus,
    required this.listType,
    required this.errorMessage,
    this.selectedtype,
    this.currentPage = 1,
    this.totalPage = 1,
    // this.searchKey,
  });

  factory TypeDocState.initial() {
    return TypeDocState(
      typeStatus: TypeStatus.initial,
      listType: [],
      currentPage: 1,
      totalPage: 1,
      errorMessage: "",
      
    );
  }

  TypeDocState copyWith({
    TypeStatus? typeStatus,
    List<TypeDocModel>? listType,
    TypeDocModel? selectedtype,
    int? currentPage,
    int? totalPage,
    String? errorMessage,
    
    // String? searchKey,
  }) {
    return TypeDocState(
      typeStatus: typeStatus ?? this.typeStatus,
      listType: listType ?? this.listType,
      selectedtype: selectedtype ?? this.selectedtype,
      errorMessage: errorMessage ?? this.errorMessage,
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage ?? this.totalPage,
      // searchKey: searchKey ?? this.searchKey,
    );
  }

  @override
  List<Object?> get props => [
        typeStatus,
        listType,
        selectedtype,
        currentPage,
        totalPage,
        errorMessage,
      ];
}
