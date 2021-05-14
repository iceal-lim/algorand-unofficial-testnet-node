FROM arm64v8/ubuntu

RUN apt-get update -y && \
    apt-get install -y gnupg2 curl software-properties-common wget

RUN mkdir -p /node

WORKDIR /node

ADD start_node.sh .

RUN wget https://raw.githubusercontent.com/algorand/go-algorand-doc/master/downloads/installers/update.sh && \
    chmod 544 update.sh

RUN chmod +x start_node.sh

RUN ./update.sh -i -c stable -p /node -d /node/data -n

RUN cp /node/genesisfiles/testnet/genesis.json /node/data/genesis.json

ADD algod.token config.json /node/data/

CMD ["./start_node.sh"]