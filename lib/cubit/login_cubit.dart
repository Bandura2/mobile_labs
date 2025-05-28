import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';

class LoginState extends Equatable {
  final String? errorMessage;
  final bool isSuccess;

  const LoginState({this.errorMessage, required this.isSuccess});

  factory LoginState.initial() =>
      const LoginState(errorMessage: null, isSuccess: false);

  LoginState copyWith({String? errorMessage, bool? isSuccess}) {
    return LoginState(
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [errorMessage, isSuccess];
}

class LoginCubit extends Cubit<LoginState> {
  final SharedPrefsUserRepository userRepository;

  LoginCubit({required this.userRepository}) : super(LoginState.initial());

  Future<void> loginUser(String email, String password) async {
    emit(state.copyWith(errorMessage: null));

    final savedUser = await userRepository.getUser();
    if (savedUser != null &&
        email.trim() == savedUser.email &&
        password.trim() == savedUser.password) {
      await userRepository.setUserLoggedIn(true);
      emit(state.copyWith(isSuccess: true));
    } else {
      emit(state.copyWith(errorMessage: 'Неправильний email або пароль'));
    }
  }
}
