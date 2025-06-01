import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/screens/profile/profile_view.dart';
import 'package:lab_1/cubit/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        context.read<SharedPrefsUserRepository>(),
      ),
      child: const _ProfileScreenState(),
    );
  }
}

class _ProfileScreenState extends StatelessWidget {
  const _ProfileScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black87,
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Помилка: ${state.error}')),
            );
          }

          if (state.isLoading && !state.isLoggedIn && state.error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ви вийшли з системи')),
            );
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        builder: (context, state) {
          return ProfileView(
            isLoading: state.isLoading,
            isLoggedIn: state.isLoggedIn,
            name: state.user?.name,
            email: state.user?.email,
            onLogout: () => context.read<ProfileCubit>().logout(),
            onReload: () => context.read<ProfileCubit>().loadUserData(),
          );
        },
      ),
    );
  }
}
