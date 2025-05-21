import paho.mqtt.client as mqtt
import time
import json
import random

broker_address = "broker.hivemq.com"
port = 1883
topic = "my/distance/sensor"


def on_connect(client, userdata, flags, rc):
    if rc == 0:
        print("MQTT broker connected")
    else:
        print(f"Cennected error: {rc}")


client = mqtt.Client()
client.on_connect = on_connect

try:
    client.connect(broker_address, port, 60)
    client.loop_start()

    while True:
        distance = round(random.uniform(0, 400))

        data = {"distance": distance}
        payload = json.dumps(data)

        client.publish(topic, payload)
        print(f"Sent: {payload}")

        time.sleep(3)

except KeyboardInterrupt:
    print("Finish")
finally:
    client.loop_stop()
    client.disconnect()
