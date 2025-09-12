import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';

class SwitchPageCubit extends Cubit<SwitchPageState> {
  SwitchPageCubit() : super(SwitchPageState.initial()); // Par défaut, on commence à la page 0 (Dashboard)
  void switchPage(double pageIndex) {
    emit(state.copyWith(
        selectedPage: pageIndex,
        isDocumentExpanded: (pageIndex == 1.1 || pageIndex == 1.2 || pageIndex == 1.3),
        isCollabExpanded: (pageIndex == 5.1 || pageIndex == 5.2)));
    log('Page switched to $pageIndex');
  }

  void setDocExpanded(bool isExpanded) {
    emit(state.copyWith(isDocumentExpanded: isExpanded));
  }

  void setCollabExpanded(bool isExpanded) {
    emit(state.copyWith(isCollabExpanded: isExpanded));
  }
}
