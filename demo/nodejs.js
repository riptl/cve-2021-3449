const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('server.pem'),
  cert: fs.readFileSync('server.pem')
};

https.createServer(options, function (req, res) {
  res.writeHead(200);
  res.end("hello world\n");
}).listen(4433);

console.log("server started");
