import logging

class Client:
  def __init__(self, id, server=None, latitude=None, longitude=None, clientTime=None, serverTime=None):
    self.id = id
    self.server = server
    self.latitude = latitude
    self.longitude = longitude
    self.clientTime = clientTime
    self.serverTime = serverTime

class Storage:
  def __init__(self, id, config):
    self.id = id
    self.config = config
    self.clients = {}
    self.sentMessages = {}
    self.receivedMessages = {}

    # set up default logger
    logFile = logging.FileHandler("%s.log" % self.id)
    logFile.setFormatter(logging.Formatter("%(asctime)s - %(levelname)s - %(module)s:%(funcName)s:%(lineno)d - %(message)s"))

    logger = logging.getLogger(self.id)
    logger.setLevel(logging.INFO)
    logger.addHandler(logFile)
    self.logger = logger
