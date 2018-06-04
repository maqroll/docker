#docker pull openjdk
docker run -v ${PWD}:/root/java -w /root/java -it --rm library/openjdk bash
