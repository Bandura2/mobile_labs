import 'dart:isolate';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;

class MqttReader {
  Function(int distance)? onDistanceReceived;

  Isolate? _isolate;
  SendPort? _sendPort;
  final ReceivePort _receivePort = ReceivePort();

  Future<void> start() async {
    _receivePort.listen((message) {
      if (message is int) {
        onDistanceReceived?.call(message);
      } else if (message is SendPort) {
        _sendPort = message;
      }
    });

    _isolate = await Isolate.spawn<_IsolateMessage>(
      _mqttIsolateEntry,
      _IsolateMessage(_receivePort.sendPort),
      debugName: "MQTT_Isolate",
    );
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort.close();
  }
}

class _IsolateMessage {
  final SendPort sendPort;
  _IsolateMessage(this.sendPort);
}

void _mqttIsolateEntry(_IsolateMessage msg) async {

  print("AAA\n\n\nAAA");

  final client = mqtt.MqttServerClient('broker.hivemq.com', 'flutter_client_${DateTime.now().millisecondsSinceEpoch}');
  client.port = 1883;
  client.keepAlivePeriod = 20;
  client.logging(on: false);

  final connMessage = mqtt.MqttConnectMessage()
      .withClientIdentifier(client.clientIdentifier)
      .startClean();
  client.connectionMessage = connMessage;

  try {
    final result = await client.connect();
    if (result?.state != mqtt.MqttConnectionState.connected) {
      client.disconnect();
      return;
    }

    final isolateReceivePort = ReceivePort();
    msg.sendPort.send(isolateReceivePort.sendPort);

    client.subscribe('my/distance/sensor', mqtt.MqttQos.atMostOnce);

    client.updates?.listen((messages) {
      final mqtt.MqttPublishMessage message = messages![0].payload as mqtt.MqttPublishMessage;
      final payload = mqtt.MqttPublishPayload.bytesToStringAsString(message.payload.message);

      try {
        final data = jsonDecode(payload);
        if (data is Map<String, dynamic> && data.containsKey('distance')) {
          final distance = data['distance'];
          if (distance is int) {
            msg.sendPort.send(distance);
          } else if (distance is double) {
            msg.sendPort.send(distance.toInt());
          }
        }
      } catch (_) {
      }
    });
  } catch (_) {
    client.disconnect();
  }
}



// import 'dart:isolate';
// import 'dart:convert';
// import 'package:mqtt_client/mqtt_client.dart' as mqtt;
// import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
//
// final mqtt.MqttServerClient client = mqtt.MqttServerClient('broker.hivemq.com', 'flutter_client');
//
// class MqttReader {
//   Function(int distance)? onDistanceReceived;
//
//   Isolate? _isolate;
//   SendPort? _sendPort;
//   final ReceivePort _receivePort = ReceivePort();
//
//   Future<void> start() async {
//     _receivePort.listen((message) {
//       if (message is int) {
//         onDistanceReceived?.call(message);
//       } else if (message is SendPort) {
//         _sendPort = message;
//       }
//     });
//
//     _isolate = await Isolate.spawn(_mqttIsolateEntry, _receivePort.sendPort);
//   }
//
//   void dispose() {
//     _isolate?.kill(priority: Isolate.immediate);
//     _receivePort.close();
//   }
// }
//
// void _mqttIsolateEntry(SendPort mainSendPort) async {
//   client.port = 1883;
//   client.keepAlivePeriod = 20;
//   client.logging(on: false);
//
//   final connMessage = mqtt.MqttConnectMessage()
//       .withClientIdentifier(client.clientIdentifier)
//       .startClean();
//   client.connectionMessage = connMessage;
//
//   try {
//     final result = await client.connect();
//     if (result?.state != mqtt.MqttConnectionState.connected) {
//       client.disconnect();
//       return;
//     }
//
//     final receivePort = ReceivePort();
//     mainSendPort.send(receivePort.sendPort);
//
//     client.subscribe('my/distance/sensor', mqtt.MqttQos.atMostOnce);
//
//     client.updates?.listen((messages) {
//       final mqtt.MqttPublishMessage message =
//       messages![0].payload as mqtt.MqttPublishMessage;
//       final payload = mqtt.MqttPublishPayload.bytesToStringAsString(
//           message.payload.message);
//       try {
//         final data = jsonDecode(payload);
//         if (data is Map<String, dynamic> && data.containsKey('distance')) {
//           final distance = data['distance'];
//           if (distance is int) {
//             mainSendPort.send(distance);
//           } else if (distance is double) {
//             mainSendPort.send(distance.toInt());
//           }
//         }
//       } catch (e) {
//         client.disconnect();
//       }
//     });
//   } catch (e) {
//     client.disconnect();
//   }
// }
