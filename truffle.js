//module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
//};
module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    geth: {
      host: '35.197.122.68',
      port: 8545,
      network_id: '1243', // Matched network id
    }
  }
};
