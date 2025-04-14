const request = require('supertest');
const server = require('../app');

describe('Node.js HTTP Server', () => {
  afterAll(() => {
    server.close();
  });

  test('GET / should respond with DevOps Domination message', async () => {
    const response = await request(server).get('/');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe("Hello from DevOps Domination Server!");
  });

  test('GET /unknown should still respond with same message (no routing)', async () => {
    const response = await request(server).get('/unknown');
    expect(response.statusCode).toBe(200);
    expect(response.text).toBe("Hello from DevOps Domination Server!");
  });
});
