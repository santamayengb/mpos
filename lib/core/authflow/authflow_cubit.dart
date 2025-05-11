import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'authflow_state.dart';

class AuthflowCubit extends Cubit<AuthflowState> {
  AuthflowCubit() : super(AuthflowInitial());

  
}
