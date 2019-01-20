import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'dart:async';

class MqttUtil {
  String lbroker = '192.168.4.1';
  // int port = 1883;

  mqtt.MqttClient client;
  mqtt.MqttConnectionState connectionState;

  StreamSubscription subscription;

  String topic = 'smart-switch/mainhub';

  void lconnect() async {
    client = mqtt.MqttClient(lbroker, '');
    // client.port = port;

    client.logging(on: false);

    client.keepAlivePeriod = 30;

    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('fromFlutter')
        .startClean()
        .keepAliveFor(30);
    print('MQTT client connecting');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print(e);
      // _disconnect();
    }

    if (client?.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
    } else {
      print('ERROR: MQTT client connection failed - '
          'reconnecting, state is ${client.connectionStatus.state}');
      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);

  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    print(event.length);
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    /// The above may seem a little convoluted for users only interested in the
    /// payload, some users however may be interested in the received publish message,
    /// lets not constrain ourselves yet until the package has been in the wild
    /// for a while.
    /// The payload is a byte buffer, this will be specific to the topic
    print('MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    print(client?.connectionStatus?.state);
  }

  bool checkMqttConnectionLocal() {
    lconnect();

    if (client?.connectionStatus?.state == mqtt.MqttConnectionState.connected) {
      print('Local MQTT client connected');
      subscribeToTopic(topic);
      print('Subscribed to Topic : $topic');
      return true;
    } else {
      print('ERROR: Local MQTT client connection failed - '
          'Retrying, state is ${client.connectionStatus.state}');
    }
    return false;
  }

  void _disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('MQTT client disconnected');
  }

  void subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('Subscribing to $topic');
      client.subscribe(topic, mqtt.MqttQos.atMostOnce);
    }
  }

  void unsubscribeFromTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      print('Unsubscribing from $topic');
      client.unsubscribe(topic);
    }
  }

  void postData(String room, String switchName, String toggle) {
    final mqtt.MqttClientPayloadBuilder builder =
        mqtt.MqttClientPayloadBuilder();

    String _messageContent = '{ "room" : "$room", "switchName": "$switchName", "status" : "$toggle" }';
    print("Message $_messageContent sent");
    builder.addString(_messageContent);
    client.publishMessage(topic, mqtt.MqttQos.atMostOnce, builder.payload,
        retain: false);
  }
}
