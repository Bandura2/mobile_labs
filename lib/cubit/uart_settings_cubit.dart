import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_1/receivers_from_sensor/uart_comunication_controller.dart';

enum ConnectionStatus {
  notConnected,
  connecting,
  connected,
  error,
}

extension ConnectionStatusExtension on ConnectionStatus {
  String get label {
    switch (this) {
      case ConnectionStatus.notConnected:
        return 'Не підключено';
      case ConnectionStatus.connecting:
        return 'Підключення...';
      case ConnectionStatus.connected:
        return 'Підключено';
      case ConnectionStatus.error:
        return 'Помилка підключення';
    }
  }
}

class UARTSettingsState extends Equatable {
  final ConnectionStatus connectionStatus;
  final String username;
  final String password;
  final String deviceId;

  const UARTSettingsState({
    required this.connectionStatus,
    required this.username,
    required this.password,
    required this.deviceId,
  });

  UARTSettingsState copyWith({
    ConnectionStatus? connectionStatus,
    String? username,
    String? password,
    String? deviceId,
  }) {
    return UARTSettingsState(
      connectionStatus: connectionStatus ?? this.connectionStatus,
      username: username ?? this.username,
      password: password ?? this.password,
      deviceId: deviceId ?? this.deviceId,
    );
  }

  @override
  List<Object?> get props => [connectionStatus, username, password, deviceId];
}

class UARTSettingsCubit extends Cubit<UARTSettingsState> {
  final UartCommunicationController uartController;

  UARTSettingsCubit(this.uartController)
      : super(const UARTSettingsState(
          connectionStatus: ConnectionStatus.notConnected,
          username: '',
          password: '',
          deviceId: '',
        )) {
    initializeUart();
  }

  Future<void> initializeUart() async {
    emit(state.copyWith(connectionStatus: ConnectionStatus.connecting));
    bool success = await uartController.initialize();
    emit(state.copyWith(
      connectionStatus:
          success ? ConnectionStatus.connected : ConnectionStatus.error,
    ));
  }

  void updateCredentials({String? username, String? password}) {
    emit(state.copyWith(
      username: username ?? state.username,
      password: password ?? state.password,
    ));
  }

  void updateDeviceId(String deviceId) {
    emit(state.copyWith(deviceId: deviceId));
  }

  Future<String?> sendCredentials() async {
    if (state.connectionStatus != ConnectionStatus.connected) return null;

    final response = await uartController.sendCredentials(
      username: state.username,
      password: state.password,
      deviceId: state.deviceId,
    );

    if (response != null) {
      final parts = response.trim().split(':');
      if (parts.length == 2) {
        final status = parts[0];
        final id = parts[1];
        if (status == "AUTH_SUCCESS" || status == "ID_UPDATED") {
          updateDeviceId(id);
        }
        return 'Відповідь МК: $status, ID: $id';
      } else {
        return 'Невірний формат відповіді від МК: $response';
      }
    } else {
      return 'Немає відповіді від МК';
    }
  }

  Future<String?> requestCurrentDeviceId() async {
    if (state.connectionStatus != ConnectionStatus.connected) return null;

    final response = await uartController.sendCredentials(
      username: state.username,
      password: state.password,
      deviceId: "0",
    );

    if (response != null) {
      final parts = response.trim().split(':');
      if (parts.length == 2 && parts[0] == "AUTH_SUCCESS") {
        updateDeviceId(parts[1]);
        return 'Поточний ідентифікатор від МК: ${parts[1]}';
      } else {
        return 'Помилка запиту ID: ${response.trim()}';
      }
    } else {
      return 'Немає відповіді від МК при запиті ID';
    }
  }
}
