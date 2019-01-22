docker run  -p 8888:8888 -v $(pwd):/code  -e PASSWORD=$1 -d smizy/scikit-learn
