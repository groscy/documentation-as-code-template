#!/bin/sh

./bin/structurizr-cli/structurizr.sh \
 export -w src/domain/kibon.dsl \
  -format plantuml/structurizr \
  -output resources/diagrams
