import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';

class UartCommunicationController {
  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;

  Completer<String>? _responseCompleter;

  Future<bool> initialize() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      return false;
    }

    UsbDevice device = devices.first;
    _port = await device.create();
    bool openResult = await _port!.open();

    if (!openResult) {
      return false;
    }

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
      9600,
      UsbPort.DATABITS_8,
      UsbPort.STOPBITS_1,
      UsbPort.PARITY_NONE,
    );

    startListening();

    return true;
  }

  void startListening() {
    if (_port == null) return;

    _subscription = _port!.inputStream?.listen((data) {
      try {
        final response = utf8.decode(data);

        _responseCompleter?.complete(response);
        _responseCompleter = null;
      } catch (e) {
        _responseCompleter?.completeError('Failed to decode response: $e');
        _responseCompleter = null;
      }
    }, onError: (error) {
      _responseCompleter?.completeError('USB stream error: $error');
      _responseCompleter = null;
    }, onDone: () {
      _responseCompleter?.completeError('USB stream closed');
      _responseCompleter = null;
    });
  }

  Future<String?> sendMessageAndWaitResponse(String message) async {
    if (_port == null) {
      bool success = await initialize();
      if (!success) {
        return null;
      }
    }

    _responseCompleter = Completer<String>();

    try {
      Uint8List dataToSend = Uint8List.fromList(utf8.encode(message));
      await _port!.write(dataToSend);
      final response = await _responseCompleter!.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          _responseCompleter = null;
          return 'Timeout waiting for response';
        },
      );
      return response;
    } catch (e) {
      _responseCompleter = null;
      return null;
    }
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;

    if (_port != null) {
      await _port?.close();
    }
    _port = null;
    _responseCompleter = null;
  }

  Future<String?> sendCredentials({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    final message = "$username:$password:$deviceId";
    return await sendMessageAndWaitResponse(message);
  }

  Future<String?> requestDeviceId() async {
    final message = 'read\x00\x00\x00';
    return await sendMessageAndWaitResponse(message);
  }

  Future<String?> flashDeviceId(String newDeviceId) async {
    const defaultUsername = "admin";
    const defaultPassword = "12345";

    final message = "$defaultUsername:$defaultPassword:$newDeviceId";
    return await sendMessageAndWaitResponse(message);
  }
}
