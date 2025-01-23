import 'package:doc_authentificator/cubits/types/type_doc_state.dart';
import 'package:doc_authentificator/models/type_doc_model.dart';
import 'package:doc_authentificator/repositories/type_doc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeDocCubit extends Cubit<TypeDocState> {
  final TypeDocRepository typeDocRepository;
  TypeDocCubit({
    required this.typeDocRepository,
  }) : super(TypeDocState.initial()) {}

  Future<void> getAllType(int page) async {
    try {
      emit(state.copyWith(
          typeStatus: TypeStatus.loading, errorMessage: ""));
      final List<TypeDocModel> types =
          await typeDocRepository.getAllType(page);
            // final int totalPages = response['last_page'];
      emit(state.copyWith(
          typeStatus: TypeStatus.loaded,
          listType: types,currentPage: page,totalPage: 10 ,
          errorMessage: ""));
    } catch (e) {
      emit(state.copyWith(
          errorMessage: e.toString(), typeStatus: TypeStatus.error));
    }
  }
}
