const http = require("http");
const fs = require("fs");
const path = require("path");

const port = 3000;
const buildDir = path.join(__dirname, "build");

const contentTypes = {
  ".html": "text/html",
  ".js": "text/javascript",
  ".css": "text/css",
  ".json": "application/json",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".ico": "image/x-icon",
};

function sendFile(filePath, res) {
  fs.readFile(filePath, (err, data) => {
    if (err) {
      res.writeHead(500);
      res.end("Server error");
      return;
    }

    const extension = path.extname(filePath);

    res.writeHead(200, {
      "Content-Type": contentTypes[extension] || "application/octet-stream",
    });

    res.end(data);
  });
}

const server = http.createServer((req, res) => {
  const requestPath = req.url.split("?")[0];

  if (requestPath === "/health") {
    res.writeHead(200, {
      "Content-Type": "application/json",
    });

    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  const filePath = path.join(
    buildDir,
    requestPath === "/" ? "index.html" : requestPath
  );

  fs.stat(filePath, (err, stats) => {
    if (!err && stats.isFile()) {
      sendFile(filePath, res);
      return;
    }

    // React SPA fallback
    sendFile(path.join(buildDir, "index.html"), res);
  });
});

server.listen(port, "0.0.0.0", () => {
  console.log(`Threat Composer listening on port ${port}`);
});