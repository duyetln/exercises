from twisted.internet import protocol, reactor
from servermessage import ServerMessage, ServerMessageFactory
from core import Client, Storage

import project_config
import uuid
import re
import time
import urllib2
import json

class  UnprocessableMessage(Exception):
  pass

class LocationServerProtocol(protocol.Protocol):
  def dataReceived(self, message):
    storage = self.factory.storage
    storage.logger.info("Message received %s" % repr(message))

    chunks = message.strip().split()
    try:
      if len(chunks) < 1:
        raise UnprocessableMessage()
      elif chunks[0].upper() == "IAMAT" and len(chunks) >= 4:
        self.handleClientIAMAT(chunks)
      elif chunks[0].upper() == "WHATSAT" and len(chunks) >= 4:
        self.handleClientWHATSAT(chunks)
      elif chunks[0] in storage.config.keys(): # server message received
        senderId, messageId = chunks[0:2]
        if senderId not in storage.receivedMessages or messageId not in storage.receivedMessages[senderId]: # message has not been seen before
          if senderId not in storage.receivedMessages:
            storage.receivedMessages[senderId] = {}
          storage.receivedMessages[senderId][messageId] = message
          if senderId != storage.id: # message was not sent by the same server
            if chunks[2] == "GET":
              self.handleServerGET(chunks)
            elif chunks[2] == "POST":
              self.handleServerPOST(chunks)
      else:
        raise UnprocessableMessage()
    except UnprocessableMessage:
      response = "? %s\n" % " ".join(chunks)
      storage.logger.info("Responded %s" % repr(response))
      self.transport.write(response)

  def connectionMade(self):
    storage = self.factory.storage
    storage.logger.info("New connection established")

  def connectionLost(self, reason):
    storage = self.factory.storage
    storage.logger.info("Connection lost")

  def handleClientIAMAT(self, chunks):
    storage = self.factory.storage

    # update or create new client
    client = self.extract_client("IAMAT", chunks)
    if client.clientTime < 0:
      raise UnprocessableMessage()
    storage.clients[client.id] = client

    self.sendServerMessage("POST", client)
    response = "AT %s %.9f %s %s %.9f\n" % (
      client.server,
      client.serverTime - client.clientTime,
      client.id,
      client.latitude + client.longitude,
      client.clientTime
    )
    storage.logger.info("Responded %s" % repr(response))
    self.transport.write(response)

  def handleClientWHATSAT(self, chunks):
    storage = self.factory.storage

    clientId = chunks[1]
    radius = float(chunks[2])
    resultNum = int(chunks[3])

    if radius > 50:
      raise UnprocessableMessage()
    if resultNum < 1:
      raise UnprocessableMessage()

    if clientId in storage.clients:
      client = storage.clients[clientId]

      # call google place api
      url = "%s?key=%s&location=%s,%s&radius=%.3f" % (
        project_config.API_URL,
        project_config.API_KEY,
        client.latitude,
        client.longitude,
        radius * 1000
      )
      results = json.loads(urllib2.urlopen(url).read())
      results["results"] = results["results"][:resultNum]

      response = "AT %s %.9f %s %s %.9f\n%s\n" % (
        client.server,
        client.serverTime - client.clientTime,
        client.id,
        client.latitude + client.longitude,
        client.clientTime,
        json.dumps(results)
      )
      storage.logger.info("Responded %s" % repr(response))
      self.transport.write(response)
    else:
      self.sendServerMessage("GET", Client(clientId))
      raise UnprocessableMessage()

  def handleServerGET(self, chunks):
    storage = self.factory.storage

    clientId = chunks[3]
    if clientId in storage.clients:
      client = storage.clients[clientId]
      self.sendServerMessage("POST", client)

    # forward the message to neighboring servers
    self.sendServerMessage(chunks[2], Client(clientId), chunks[0], chunks[1])

  def handleServerPOST(self, chunks):
    storage = self.factory.storage

    client = self.extract_client("POST", chunks)

    if client.id not in storage.clients or client.clientTime > storage.clients[client.id].clientTime:
      storage.clients[client.id] = client

      # forward the message to neighboring servers
      self.sendServerMessage(chunks[2], client, chunks[0], chunks[1])
    else:
      self.sendServerMessage("POST", storage.clients[client.id])

  # optional arguments: senderId, messageId (used for forwarding messages; super ad-hoc)
  def sendServerMessage(self, type, client, senderId=None, messageId=None):
    storage = self.factory.storage
    config = storage.config

    if not senderId:
      senderId = storage.id
    if not messageId:
      messageId = uuid.uuid1().hex

    for neighbor in map(lambda x: config[x], config[storage.id]["neighbors"]):
      reactor.connectTCP(
        neighbor["host"],
        neighbor["port"],
        ServerMessageFactory(storage, senderId, messageId, type, client)
      )

  def extract_client(self, type, chunks):
    storage = self.factory.storage

    if type == "IAMAT":
      latitude, longitude = re.findall("[-+]\d+\.\d+|[-+]\d+", chunks[2])
      return Client(chunks[1], storage.id, latitude, longitude, float(chunks[3]), time.time())
    elif type == "POST":
      latitude, longitude = re.findall("[-+]\d+\.\d+|[-+]\d+", chunks[5])
      return Client(chunks[3], chunks[4], latitude, longitude, float(chunks[6]), float(chunks[7]))

class LocationServer(protocol.ServerFactory):
  def __init__(self, storage):
    self.storage = storage
    self.protocol = LocationServerProtocol
