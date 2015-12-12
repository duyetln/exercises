API_URL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
API_KEY = "API_KEY"

SERVERS = {
  "ALFORD": {
    "host": "localhost",
    "port": 3000,
    "neighbors": [
      "POWELL",
      "PARKER"
    ]
  },
  "BOLDEN": {
    "host": "localhost",
    "port": 3001,
    "neighbors": [
      "POWELL",
      "PARKER"
    ]
  },
  "HAMILTON": {
    "host": "localhost",
    "port": 3002,
    "neighbors": [
      "PARKER"
    ]
  },
  "PARKER": {
    "host": "localhost",
    "port": 3003,
    "neighbors": [
      "ALFORD",
      "BOLDEN",
      "HAMILTON"
    ]
  },
  "POWELL": {
    "host": "localhost",
    "port": 3004,
    "neighbors": [
      "ALFORD",
      "BOLDEN"
    ]
  }
}
