from twisted.internet import protocol

class ServerMessage(protocol.Protocol):
  def connectionMade(self):
    messageId, message = self.message()

    self.factory.storage.logger.info("New connection established")
    self.factory.storage.logger.info("Send server message %s" % repr(message))

    self.transport.write(message)
    self.factory.storage.sentMessages[messageId] = message
    self.transport.loseConnection()

  def connectionLost(self, reason):
    pass # add logging here

  def message(self):
    senderId = self.factory.senderId
    messageId = self.factory.messageId
    type = self.factory.type
    client = self.factory.client

    if type == "GET":
      return (messageId, "%s %s %s %s" % (
        senderId,
        messageId,
        type,
        client.id
      ))
    elif type == "POST":
      return (messageId, "%s %s %s %s %s %s%s %.9f %.9f" % (
        senderId,
        messageId,
        type,
        client.id,
        client.server,
        client.latitude,
        client.longitude,
        client.clientTime,
        client.serverTime
      ))

# used only for sending one message to servers
class ServerMessageFactory(protocol.ClientFactory):
  def __init__(self, storage, senderId, messageId, type, client):
    self.storage = storage
    self.senderId = senderId
    self.messageId = messageId
    self.type = type.upper()
    self.client = client
    self.protocol = ServerMessage

  def clientConnectionFailed(self, connector, reason):
    storage = self.storage
    storage.logger.info("New connection failed")

  def clientConnectionLost(self, connector, reason):
    storage = self.storage
    storage.logger.info("Connection lost")
