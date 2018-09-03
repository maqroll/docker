docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -e HOST_IP=host.docker.internal -e ZK=host.docker.internal:2181 -i -t wurstmeister/kafka /bin/bash
