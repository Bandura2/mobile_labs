import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab_1/screens/qr_scaner_screen.dart';
import 'package:lab_1/cubit/uart_settings_cubit.dart';

class UARTSettingsView extends StatelessWidget {
  const UARTSettingsView({super.key});

  void showSnackBarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UARTSettingsCubit>();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final deviceIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('UART Налаштування')),
      body: BlocConsumer<UARTSettingsCubit, UARTSettingsState>(
        listener: (context, state) {
          usernameController.text = state.username;
          passwordController.text = state.password;
          deviceIdController.text = state.deviceId;
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Статус підключення: ${state.connectionStatus.label}',
                  style: TextStyle(
                    color: state.connectionStatus == ConnectionStatus.connected
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Сканувати QR-код'),
                  onPressed: () async {
                    final navigator = Navigator.of(context);

                    final Map<String, dynamic>? scannedData =
                        await navigator.push(
                      MaterialPageRoute(
                        builder: (context) => const QRScannerScreen(),
                      ),
                    );

                    if (scannedData != null) {
                      cubit.updateCredentials(
                        username: scannedData['username']?.toString(),
                        password: scannedData['password']?.toString(),
                      );
                      showSnackBarMessage(
                          context, 'Креденціали отримано з QR-коду');
                    } else {
                      showSnackBarMessage(
                        context,
                        'Сканування QR-коду скасовано або дані не отримано/некоректний формат',
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Ім\'я користувача',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      cubit.updateCredentials(username: value),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) =>
                      cubit.updateCredentials(password: value),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: deviceIdController,
                  decoration: const InputDecoration(
                    labelText: 'Ідентифікатор',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => cubit.updateDeviceId(value),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final response = await cubit.sendCredentials();
                    showSnackBarMessage(
                      context,
                      response ?? 'Будь ласка, дочекайтеся підключення до МК',
                    );
                  },
                  child: const Text('Ідентифікація / Перезапис'),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final response = await cubit.requestCurrentDeviceId();
                    showSnackBarMessage(
                      context,
                      response ?? 'Будь ласка, дочекайтеся підключення до МК',
                    );
                  },
                  child: const Text('Запитати поточний ідентифікатор з МК'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
