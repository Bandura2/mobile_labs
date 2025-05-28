import 'package:lab_1/models/user.dart';
import 'package:lab_1/repositories/shared_prefs_user_repository.dart';
import 'package:lab_1/receivers_from_sensor/data_from_sensors.dart';
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final SharedPrefsUserRepository _userRepository;

  ProfileCubit(this._userRepository) : super(const ProfileState.loading()) {
    loadUserData();
  }

  Future<void> loadUserData() async {
    emit(const ProfileState.loading());

    try {
      final isLoggedIn = await _userRepository.isUserLoggedIn();
      if (isLoggedIn) {
        final user = await _userRepository.getUser();
        emit(ProfileState.loaded(user!));
      } else {
        emit(const ProfileState.loggedOut());
      }
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _userRepository.logout();
      emit(const ProfileState.loggedOut());
    } catch (e) {
      emit(ProfileState.error(e.toString()));
    }
  }
}

class ProfileState {
  final bool isLoading;
  final User? user;
  final String? error;

  const ProfileState._({
    required this.isLoading,
    this.user,
    this.error,
  });

  const ProfileState.loading() : this._(isLoading: true);

  const ProfileState.loaded(User user) : this._(isLoading: false, user: user);

  const ProfileState.loggedOut() : this._(isLoading: false);

  const ProfileState.error(String error)
      : this._(isLoading: false, error: error);

  bool get isLoggedIn => user != null;
}

final client = mqtt.MqttServerClient('broker.hivemq.com', 'flutter_client');

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  late MqttReader mqttReader;

  ProfileInfoCubit() : super(const ProfileInfoState(sensorValue: 0)) {
    _initializeMqtt();
  }

  void _initializeMqtt() {
    mqttReader = MqttReader(client);

    mqttReader.onDistanceReceived = (int distance) {
      emit(ProfileInfoState(sensorValue: distance));
    };

    mqttReader.start();
  }
}

class ProfileInfoState {
  final int sensorValue;

  const ProfileInfoState({required this.sensorValue});
}
