import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_1/models/user.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const RegisterState({
    required this.isLoading,
    required this.isSuccess,
    this.errorMessage,
  });

  factory RegisterState.initial() => const RegisterState(
        isLoading: false,
        isSuccess: false,
        errorMessage: null,
      );

  RegisterState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage];
}

class RegisterCubit extends Cubit<RegisterState> {
  final SharedPrefsUserRepository userRepository;

  RegisterCubit({required this.userRepository})
      : super(RegisterState.initial());

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = User(
        name: name.trim(),
        email: email.trim(),
        password: password.trim(),
      );

      await userRepository.saveUser(user);
      await userRepository.setUserLoggedIn(true);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
          state.copyWith(isLoading: false, errorMessage: 'Помилка реєстрації'));
    }
  }
}
