#!/bin/bash

set -x
set -e

# Copyright Jiaqi Liu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

export NEO4J_URI=${NEO4J_URI}
export NEO4J_USERNAME=${NEO4J_USERNAME}
export NEO4J_PASSWORD=${NEO4J_PASSWORD}
export NEO4J_DATABASE=${NEO4J_DATABASE}

export JETTY_HOME=${HOME_DIR}/jetty-home-11.0.15
cd ${HOME_DIR}/jetty-base
java -jar $JETTY_HOME/start.jar &

# Delete old routing rules
curl -X DELETE  https://api.paion-data.dev:8444/routes/wilhelm-ws-languages
curl -X DELETE  https://api.paion-data.dev:8444/services/wilhelm-ws-languages
curl -X DELETE  https://api.paion-data.dev:8444/routes/wilhelm-ws-expand
curl -X DELETE  https://api.paion-data.dev:8444/services/wilhelm-ws-expand
curl -X DELETE  https://api.paion-data.dev:8444/routes/wilhelm-ws-expand
curl -X DELETE  https://api.paion-data.dev:8444/services/wilhelm-ws-search

# Add new routing rule - vocabulary paged & count
curl -v -i -s -k -X POST https://api.paion-data.dev:8444/services \
  --data name=wilhelm-ws-languages \
  --data url="http://$(hostname -I | awk '{print $1}'):8080/v1/neo4j/languages"
curl -i -k -X POST https://api.paion-data.dev:8444/services/wilhelm-ws-languages/routes \
  --data "paths[]=/wilhelm/languages" \
  --data name=wilhelm-ws-languages

# Add new routing rule - expand
curl -v -i -s -k -X POST https://api.paion-data.dev:8444/services \
  --data name=wilhelm-ws-expand \
  --data url="http://$(hostname -I | awk '{print $1}'):8080/v1/neo4j/expand"
curl -i -k -X POST https://api.paion-data.dev:8444/services/wilhelm-ws-expand/routes \
  --data "paths[]=/wilhelm/expand" \
  --data name=wilhelm-ws-expand

# Add new routing rule - search
curl -v -i -s -k -X POST https://api.paion-data.dev:8444/services \
  --data name=wilhelm-ws-search \
  --data url="http://$(hostname -I | awk '{print $1}'):8080/v1/neo4j/search"
curl -i -k -X POST https://api.paion-data.dev:8444/services/wilhelm-ws-search/routes \
  --data "paths[]=/wilhelm/search" \
  --data name=wilhelm-ws-search
