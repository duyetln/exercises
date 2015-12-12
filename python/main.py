from twisted.internet import reactor
from locationserver import *

import project_config

config = project_config.SERVERS

# set up ALFORD server
alford = LocationServer(Storage("ALFORD", config))
reactor.listenTCP(config["ALFORD"]["port"], alford)

# set up BOLDEN server
bolden = LocationServer(Storage("BOLDEN", config))
reactor.listenTCP(config["BOLDEN"]["port"], bolden)

# set up HAMILTON server
hamilton = LocationServer(Storage("HAMILTON", config))
reactor.listenTCP(config["HAMILTON"]["port"], hamilton)

# set up PARKER server
parker = LocationServer(Storage("PARKER", config))
reactor.listenTCP(config["PARKER"]["port"], parker)

# set up POWELL server
powell = LocationServer(Storage("POWELL", config))
reactor.listenTCP(config["POWELL"]["port"], powell)

reactor.run()
