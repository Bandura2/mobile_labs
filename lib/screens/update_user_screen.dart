import 'package:flutter/material.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/widgets/custom_textfield.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/validations/validation_register_fields.dart';
import 'package:lab_1/models/user.dart';
import 'package:provider/provider.dart';

class UpdateUserScreen extends StatelessWidget {
  const UpdateUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    final userRepository = context.read<SharedPrefsUserRepository>();

    return FutureBuilder<User?>(
      future: userRepository.getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        if (user != null) {
          nameController.text = user.name;
          emailController.text = user.email;
          passwordController.text = user.password;
        }

        Future<void> updateUser() async {
          if (formKey.currentState!.validate()) {
            final updatedUser = User(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              isLoggedIn: true,
            );

            final navigator = Navigator.of(context);

            await userRepository.updateUser(updatedUser);

            navigator.pushReplacementNamed('/profile');
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Редагування профілю'),
            backgroundColor: Colors.black87,
            foregroundColor: Colors.white,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(128),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomTextField(
                          label: "Ім'я",
                          controller: nameController,
                          validator: Validators.validateName,
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
                          text: 'Оновити профіль',
                          onPressed: updateUser,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
