#!/bin/bash

# https://solargraph.org/guides/rails
bin/solargraph bundle

bin/overcommit --install

docker-compose run --rm app bundle
docker-compose run --rm app bin/rails db:migrate
