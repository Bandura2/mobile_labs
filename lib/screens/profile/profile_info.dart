import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/cubit/profile_cubit.dart';

class ProfileInfo extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;

  const ProfileInfo({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileInfoCubit(),
      child: ProfileInfoView(
        name: name,
        email: email,
        onLogout: onLogout,
      ),
    );
  }
}

class ProfileInfoView extends StatelessWidget {
  final String name;
  final String email;
  final VoidCallback onLogout;

  const ProfileInfoView({
    super.key,
    required this.name,
    required this.email,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Профіль',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text('Привіт, $name!', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(email, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
          builder: (context, state) {
            return Text(
              'Значення давача: ${state.sensorValue} см',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () => Navigator.pushNamed(context, '/uart_settings'),
          text: 'Налаштування UART-ту',
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () => Navigator.pushNamed(context, '/update'),
          text: 'Редагувати профіль',
        ),
        const SizedBox(height: 20),
        CustomButton(onPressed: onLogout, text: 'Вийти з акаунту'),
      ],
    );
  }
}
