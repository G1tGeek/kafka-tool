import time
import requests
from kafka import KafkaProducer
import json

# Kafka producer setup
producer = KafkaProducer(
    bootstrap_servers='{{ kafka_host }}:{{ kafka_port }}',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Finnhub API setup
API_KEY = "cu2eg8pr01ql7sc7bkbgcu2eg8pr01ql7sc7bkc0"
FINNHUB_URL = "https://finnhub.io/api/v1/quote?symbol=AAPL"

def fetch_finnhub_data():
    try:
        response = requests.get(FINNHUB_URL, params={"token": API_KEY})
        response.raise_for_status()
        data = response.json()
        return data
    except requests.RequestException as e:
        print(f"Error fetching data from Finnhub: {e}")
        return None

if __name__ == "__main__":
    while True:
        data = fetch_finnhub_data()
        if data:
            producer.send("FINNhub", data)
            producer.flush()
            print(f"Data sent to Kafka topic 'FINNhub': {data}")
        time.sleep(10)  # Wait 10 seconds before fetching data again
