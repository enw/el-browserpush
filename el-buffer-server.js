var net = require('net');
var gotString = false;
var s = '<html><head><META HTTP-EQUIV="refresh" CONTENT="1"></head><body>page will reload with contents of emacs buffer</body</html>';
var server = net.createServer(function(c) { //'connection' listener
  console.log('server connected');
  c.on('end', function() {
    console.log('server disconnected');
  });
  c.on('data', function (d) {
//      console.log('data', d.toString());
      s = d;
      gotString = true;
  });
  c.write('hello from js \r\n');
  c.pipe(c);
});
server.listen(8889, function() { //'listening' listener
  console.log('server bound');
});

var http = require('http');
http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': gotString?'text/plain':'text/html'});
    res.end(s);
}).listen(1337, '127.0.0.1');
console.log('Server running at http://127.0.0.1:1337/');
