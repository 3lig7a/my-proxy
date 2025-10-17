import http from "http";
import https from "https";
import net from "net";
import url from "url";

const server = http.createServer((req, res) => {
  const { method, url: reqUrl, headers } = req;
  const parsedUrl = url.parse(reqUrl);

  const options = {
    hostname: parsedUrl.hostname,
    port: parsedUrl.port || 80,
    path: parsedUrl.path,
    method,
    headers,
  };

  const proxyReq = http.request(options, (proxyRes) => {
    res.writeHead(proxyRes.statusCode, proxyRes.headers);
    proxyRes.pipe(res);
  });

  proxyReq.on("error", (err) => {
    res.writeHead(500);
    res.end("Proxy error: " + err.message);
  });

  req.pipe(proxyReq);
});

// دعم CONNECT (لبروكسي HTTPS)
server.on("connect", (req, clientSocket, head) => {
  const { port, hostname } = url.parse(`//${req.url}`, false, true);
  const serverSocket = net.connect(port || 443, hostname, () => {
    clientSocket.write("HTTP/1.1 200 Connection Established\r\n\r\n");
    serverSocket.write(head);
    serverSocket.pipe(clientSocket);
    clientSocket.pipe(serverSocket);
  });
});

const PORT = process.env.PORT || 8080;
server.listen(PORT, () => console.log("Proxy running on port", PORT));

