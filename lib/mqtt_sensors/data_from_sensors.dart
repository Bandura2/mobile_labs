import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;


class MqttReader {
  final mqtt.MqttServerClient client;
  Function(int distance)? onDistanceReceived;

  MqttReader(this.client) {
    client.port = 1883;
    client.logging(on: false);
    client.keepAlivePeriod = 20;
  }

  Future<void> start() async {
    try {
      final connMessage = mqtt.MqttConnectMessage()
          .withClientIdentifier(client.clientIdentifier)
          .startClean();
      client.connectionMessage = connMessage;

      final result = await client.connect();
      if (result?.state != mqtt.MqttConnectionState.connected) {
        client.disconnect();
        return;
      }

      client.subscribe('my/distance/sensor', mqtt.MqttQos.atMostOnce);

      client.updates?.listen(
        (List<mqtt.MqttReceivedMessage<mqtt.MqttMessage>>? messages) {
          final mqtt.MqttPublishMessage message =
              messages![0].payload as mqtt.MqttPublishMessage;
          final payload = mqtt.MqttPublishPayload.bytesToStringAsString(
              message.payload.message);

          try {
            final data = jsonDecode(payload);
            if (data is Map<String, dynamic> && data.containsKey('distance')) {
              final distance = data['distance'];
              if (distance is int) {
                onDistanceReceived?.call(distance);
              } else if (distance is double) {
                onDistanceReceived?.call(distance.toInt());
              } else {}
            } else {}
          } catch (e) {
            client.disconnect();
          }
        },
      );
    } catch (e) {
      client.disconnect();
    }
  }
}
