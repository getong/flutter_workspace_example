const http = require("http");

const server = http.createServer((req, res) => {
  console.log(`${req.method} ${req.url}`);

  // Parse the request body
  let body = [];

  req.on("data", (chunk) => {
    body.push(chunk);
  });

  req.on("end", () => {
    const buffer = Buffer.concat(body);
    console.log(`Received ${buffer.length} bytes`);
    console.log(`Content-Type: ${req.headers["content-type"]}`);

    // Send back a simple response
    const responseText = `Server received your message with ${buffer.length} bytes`;
    res.writeHead(200, {
      "Content-Type": "text/plain",
      "Content-Length": responseText.length,
    });
    res.end(responseText);
  });

  req.on("error", (error) => {
    console.error("Request error:", error);
    res.writeHead(500, { "Content-Type": "text/plain" });
    res.end("Internal Server Error");
  });
});

const PORT = 8080;
server.listen(PORT, "127.0.0.1", () => {
  console.log(`Server running at http://127.0.0.1:${PORT}/`);
  console.log("Press Ctrl+C to stop the server");
});
