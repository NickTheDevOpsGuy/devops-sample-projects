const http = require('http');

const handler = (req, res) => {
  res.end("Hello from DevOps Domination Server!");
};

const server = http.createServer(handler);

if (require.main === module) {
  server.listen(3000, () => {
    console.log("🚀 Server running on http://localhost:3000");
  });
}

module.exports = server;
