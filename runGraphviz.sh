# docker pull markfletcher/graphviz
docker run --rm -itv`pwd`:/graphviz markfletcher/graphviz dot $*
