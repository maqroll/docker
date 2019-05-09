FROM mhart/alpine-node
RUN mkdir www/
WORKDIR www/
ADD . .
RUN npm config set strict-ssl false 
RUN npm install apollo-server graphql
