import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpos/routers/router.name.dart';

part 'tab_state.dart';

class TabCubit extends Cubit<TabState> {
  TabCubit() : super(const TabState(Routes.users)) {
    emit(const TabState(Routes.users));
  }
  Future activeTab(String tab) async {
    switch (tab) {
      case Routes.users:
        emit(const TabState(Routes.users));
      case Routes.products:
        emit(const TabState(Routes.products));
      case Routes.setting:
        emit(const TabState(Routes.setting));
      case Routes.inventory:
        emit(const TabState(Routes.inventory));
    }
  }
}
