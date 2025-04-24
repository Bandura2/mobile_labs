import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lab_1/widgets/custom_button.dart';
import 'package:lab_1/mqtt_sensors/data_from_sensors.dart';

class ProfileInfo extends StatefulWidget {
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
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late final RandomGenerator sensor;
  int _sensorValue = 0;

  @override
  void initState() {
    super.initState();
    sensor = RandomGenerator();
    sensor.start();
    _updateSensorValue();
  }

  void _updateSensorValue() {
    setState(() {
      _sensorValue = sensor.value;
    });

    Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _sensorValue = sensor.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Профіль',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text('Привіт, ${widget.name}!', style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 8),
        Text(widget.email, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        Text(
          'Значення давача: $_sensorValue',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        CustomButton(
          onPressed: () => Navigator.pushNamed(context, '/update'),
          text: 'Редагувати профіль',
        ),
        const SizedBox(height: 20),
        CustomButton(onPressed: widget.onLogout, text: 'Вийти з акаунту'),
      ],
    );
  }
}
