import 'package:doc_authentificator/cubits/switch_page/switch_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SwitchPageCubit extends Cubit<SwitchPageState> {
  SwitchPageCubit()
      : super(SwitchPageState.initial()); // Par défaut, on commence à la page 0 (Dashboard)
  void switchPage(int pageIndex) {
    emit(state.copyWith(selectedPage: pageIndex));
    print('Page switched to $pageIndex');
  }
}

