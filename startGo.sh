docker pull golang
docker run -v ${PWD}:/go -w /go -e GOOS='darwin' -e GOARCH='amd64' -it --rm library/golang bash
