# https://blog.docker.com/2016/09/docker-golang/
docker pull golang
docker run -v ${PWD}:/go -w /go -e GOOS='darwin' -e GOARCH='amd64' -it --rm library/golang bash
