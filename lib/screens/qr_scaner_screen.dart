import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  final void Function(Map<String, String>)? onScanned;

  const QRScannerScreen({super.key, this.onScanned});

  @override
  Widget build(BuildContext context) {
    bool isScanned = false;

    return Scaffold(
      appBar: AppBar(title: const Text('Сканування QR-коду')),
      body: MobileScanner(
        onDetect: (capture) {
          if (isScanned) return;

          final barcodes = capture.barcodes;
          if (barcodes.isEmpty) return;

          final barcode = barcodes.first;
          final String? code = barcode.rawValue;

          if (code != null) {
            isScanned = true;

            Map<String, String> resultData = {
              'username': 'ERROR',
              'password': 'ERROR'
            };

            try {
              final decoded = jsonDecode(code);
              final data = Map<String, dynamic>.from(decoded);

              resultData = {
                'username': data['username']?.toString() ?? 'EMPTY',
                'password': data['password']?.toString() ?? 'EMPTY',
              };

              if (onScanned != null) {
                onScanned!(resultData);
              }

              Navigator.pop(context, resultData);
            } catch (e) {
              final parts = code.split(':');
              if (parts.length == 2) {
                resultData = {
                  'username': parts[0],
                  'password': parts[1],
                };
                if (onScanned != null) {
                  onScanned!(resultData);
                }
                Navigator.pop(context, resultData);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Помилка при обробці QR-коду: $e. Некоректний формат даних. Очікується JSON або "username:password".')),
                );
                Navigator.pop(context,
                    {'username': 'PARSE_ERROR', 'password': 'PARSE_ERROR'});
              }
            }
          }
        },
      ),
    );
  }
}
