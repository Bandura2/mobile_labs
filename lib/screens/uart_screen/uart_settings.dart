import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/receivers_from_sensor/uart_comunication_controller.dart';
import 'package:lab_1/cubit/uart_settings_cubit.dart';
import 'package:lab_1/screens/uart_screen/uart_settings_screen.dart';

class UARTSettingsScreen extends StatelessWidget {
  const UARTSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UARTSettingsCubit(UartCommunicationController()),
      child: const UARTSettingsView(),
    );
  }
}
