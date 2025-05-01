const express = require('express');
const promClient = require('prom-client');

const app = express();
const register = new promClient.Registry();

promClient.collectDefaultMetrics({ register });

const requestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
});
register.registerMetric(requestCounter);

app.get('/', (req, res) => {
  requestCounter.inc();
  console.log('Root hit');
  res.send('Hello from Node Metrics Demo!');
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`✅ App listening on port ${port}`);
});