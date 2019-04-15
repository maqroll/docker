const { ApolloServer, gql } = require('apollo-server');

// The GraphQL schema
const typeDefs = gql`
  type Query {
    "A simple type for getting started!"
    hello: String
  }
`;

// A map of functions which return data for the schema.
const resolvers = {};

const server = new ApolloServer({
  typeDefs,
  resolvers,
  mocks: true,
  mocksEntireSchema: true,
});

server.listen().then(({ url }) => {
  console.log(`🚀 Server ready at ${url}`);
});