Steps to build and run docker image

```
docker build --rm -t telegraf .
docker run -d --privileged telegraf
docker exec -it containerid /bin/bash

```
