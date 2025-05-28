import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(
          userRepository: context.read<SharedPrefsUserRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Реєстрація'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
            Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(128),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BlocConsumer<RegisterCubit, RegisterState>(
                  listener: (context, state) {
                    if (state.isSuccess) {
                      Navigator.pushNamed(context, '/profile');
                    }
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextField(
                            label: "Ім'я",
                            controller: _nameController,
                            validator: Validators.validateName,
                          ),
                          CustomTextField(
                            label: 'Email',
                            controller: _emailController,
                            validator: Validators.validateEmail,
                          ),
                          CustomTextField(
                            label: 'Пароль',
                            isPassword: true,
                            controller: _passwordController,
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 20),
                          state.isLoading
                              ? const CircularProgressIndicator()
                              : CustomButton(
                                  text: 'Зареєструватися',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      context
                                          .read<RegisterCubit>()
                                          .registerUser(
                                            name: _nameController.text,
                                            email: _emailController.text,
                                            password: _passwordController.text,
                                          );
                                    }
                                  },
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
