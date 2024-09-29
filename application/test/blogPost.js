const request = require('supertest');

// Only demo for a api.
(async () => {
  /* eslint-disable global-require */
  const app = require('../app');
  /* eslint-enable global-require */

  describe('GET /blog/list', () => {
    it('should return 200 OK', (done) => {
      request(app)
        .get('/')
        .expect(200, done);
    });
  });
})();
