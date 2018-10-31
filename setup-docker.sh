#!/bin/bash

# build the flask container
docker build -t palerdot/foodtrucks-web .

# create the network
docker network create foodtrucks-net

# start the ES container
# give custom options so that elastic search does not give memory not enough error
docker run -d --name es --net foodtrucks-net  -p 9200:9200 -p 9300:9300 -e ES_JAVA_OPTS="-Xms256m -Xmx256m" -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:6.3.2

# start the flask app container
docker run -d --net foodtrucks-net -p 5000:5000 --name foodtrucks-web prakhar1989/foodtrucks-web
