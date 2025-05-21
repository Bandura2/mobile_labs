import 'package:flutter/material.dart';
import 'package:lab_1/camera/qr_scaner.dart';
import 'package:lab_1/receivers_from_sensor/uart_comunication_controller.dart';

class UARTSettingsScreen extends StatefulWidget {
  const UARTSettingsScreen({super.key});

  @override
  State<UARTSettingsScreen> createState() => _UARTSettingsScreenState();
}

class _UARTSettingsScreenState extends State<UARTSettingsScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController deviceIdController = TextEditingController();
  final UartCommunicationController uartController =
      UartCommunicationController();

  String _connectionStatus = 'Не підключено';

  @override
  void initState() {
    super.initState();
    _initializeUart();
  }

  Future<void> _initializeUart() async {
    setState(() {
      _connectionStatus = 'Підключення...';
    });
    bool success = await uartController.initialize();
    setState(() {
      _connectionStatus = success ? 'Підключено' : 'Помилка підключення';
      if (!success) {
        _showResponseSnackBar('Не вдалося підключитися до USB-пристрою');
      }
    });
  }

  Future<void> _scanQrCode() async {
    final Map<String, dynamic>? scannedData = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => QRScannerScreen()));

    if (scannedData != null) {
      setState(() {
        usernameController.text = scannedData['username']?.toString() ?? '';
        passwordController.text = scannedData['password']?.toString() ?? '';
      });
      _showResponseSnackBar('Креденціали отримано з QR-коду');
      print(
          'QR Data (username): ${usernameController.text}, (password): ${passwordController.text}');
    } else {
      _showResponseSnackBar(
          'Сканування QR-коду скасовано або дані не отримано/некоректний формат');
    }
  }

  Future<void> _performAction() async {
    if (_connectionStatus != 'Підключено') {
      _showResponseSnackBar('Будь ласка, дочекайтеся підключення до МК');
      return;
    }

    final username = usernameController.text;
    final password = passwordController.text;
    final deviceId = deviceIdController.text;

    if (username.isEmpty || password.isEmpty || deviceId.isEmpty) {
      _showResponseSnackBar(
          'Будь ласка, заповніть всі поля: Ім\'я користувача, Пароль та Ідентифікатор');
      return;
    }

    final response = await uartController.sendCredentials(
      username: username,
      password: password,
      deviceId: deviceId,
    );

    if (response != null) {
      final parts = response.trim().split(':');
      if (parts.length == 2) {
        final status = parts[0];
        final id = parts[1];
        _showResponseSnackBar('Відповідь МК: $status, ID: $id');
        if (status == "AUTH_SUCCESS" || status == "ID_UPDATED") {
          setState(() {
            deviceIdController.text = id;
          });
        }
      } else {
        _showResponseSnackBar('Невірний формат відповіді від МК: $response');
      }
    } else {
      _showResponseSnackBar('Немає відповіді від МК');
    }
  }

  Future<void> _requestCurrentDeviceId() async {
    if (_connectionStatus != 'Підключено') {
      _showResponseSnackBar('Будь ласка, дочекайтеся підключення до МК');
      return;
    }

    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showResponseSnackBar(
          'Будь ласка, введіть ім\'я користувача та пароль для запиту ID');
      return;
    }

    final response = await uartController.sendCredentials(
      username: username,
      password: password,
      deviceId: "0",
    );

    if (response != null) {
      final parts = response.trim().split(':');
      if (parts.length == 2 && parts[0] == "AUTH_SUCCESS") {
        setState(() {
          deviceIdController.text = parts[1];
        });
        _showResponseSnackBar('Поточний ідентифікатор від МК: ${parts[1]}');
      } else {
        _showResponseSnackBar('Помилка запиту ID: ${response.trim()}');
      }
    } else {
      _showResponseSnackBar('Немає відповіді від МК при запиті ID');
    }
  }

  void _showResponseSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UART Налаштування')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Статус підключення: $_connectionStatus',
                style: TextStyle(
                  color: _connectionStatus == 'Підключено'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Сканувати QR-код'),
              onPressed: _scanQrCode,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Ім\'я користувача',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: deviceIdController,
              decoration: const InputDecoration(
                labelText: 'Ідентифікатор',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _performAction,
              child: const Text('Ідентифікація / Перезапис'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _requestCurrentDeviceId,
              child: const Text('Запитати поточний ідентифікатор з МК'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    uartController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    deviceIdController.dispose();
    super.dispose();
  }
}
