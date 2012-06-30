local net = require "net"

-- Create a tcp server 
local server = net.createServer(function (client)
  print "connected"
  client:on("data", function (chunk)
    process.stdout:write("chunk: " .. chunk)
  end)
  client:on("end", function ()
    print "eof"
  end)
  client:on("close", function ()
    print "disconnected"
  end)
end)

-- Listen on port 8080
server:listen(8080, function ()
  print "Bound to port 8080 and listening"
end)