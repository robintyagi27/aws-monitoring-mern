require("dotenv").config();
const express = require("express");
const cors = require("cors");
const client = require("prom-client");   // <-- Prometheus client
require("./conn");

const app = express();
const PORT = process.env.PORT || 5000;

// Middlewares
app.use(express.json());
app.use(cors());

// ----------------------
// PROMETHEUS METRICS SETUP
// ----------------------

// Enable collection of default metrics (CPU, memory, event loop)
client.collectDefaultMetrics();

// Custom API request counter
const apiRequestCounter = new client.Counter({
    name: "api_requests_total",
    help: "Total API Requests",
    labelNames: ["route", "method"]
});

// Middleware to count every request
app.use((req, res, next) => {
    apiRequestCounter.inc({ route: req.path, method: req.method });
    next();
});

// Expose Prometheus metrics
app.get("/metrics", async (req, res) => {
    res.set("Content-Type", client.register.contentType);
    res.send(await client.register.metrics());
});

// ----------------------
// ROUTES
// ----------------------
const tripRoutes = require("./routes/trip.routes");

// API routes
app.use("/api/trip", tripRoutes);

// Test API
app.get("/api/test", (req, res) => {
    res.json({ message: "API is working!" });
});

// Simple test
app.get("/hello", (req, res) => {
    res.send("Hello World!");
});

// ----------------------
// START SERVER
// ----------------------
app.listen(PORT, () => {
    console.log(`Server started at http://localhost:${PORT}`);
});
