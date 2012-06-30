var net = require("net");

// Create a tcp server 
var server = net.createServer(function (client) {
  console.log("connected");
  client.on("data", function (chunk) {
    process.stdout.write("chunk: " + chunk);
  });
  client.on("end", function () {
    console.log("eof");
  });
  client.on("close", function () {
    console.log("disconnected");
  });
});

// Listen on port 8080
server.listen(8080, function () {
  console.log("Bound to port 8080 and listening");
});