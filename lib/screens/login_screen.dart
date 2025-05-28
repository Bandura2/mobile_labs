import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return BlocProvider(
      create: (context) =>
          LoginCubit(userRepository: context.read<SharedPrefsUserRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Вхід'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/background.jpg', fit: BoxFit.cover),
            Center(
              child: Container(
                height: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(128),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.isSuccess) {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (state.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(state.errorMessage!,
                                  style: const TextStyle(color: Colors.red)),
                            ),
                          CustomTextField(
                            label: 'Email',
                            controller: emailController,
                            validator: Validators.validateEmail,
                          ),
                          CustomTextField(
                            label: 'Пароль',
                            isPassword: true,
                            controller: passwordController,
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Увійти',
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<LoginCubit>().loginUser(
                                      emailController.text,
                                      passwordController.text,
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
