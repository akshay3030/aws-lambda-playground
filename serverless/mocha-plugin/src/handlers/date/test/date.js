'use strict';

// tests for date
// Generated by serverless-mocha-plugin

const mod = require('../index');
const mochaPlugin = require('serverless-mocha-plugin');

const lambdaWrapper = mochaPlugin.lambdaWrapper;
const expect = mochaPlugin.chai.expect;
const wrapped = lambdaWrapper.wrap(mod, { handler: 'handler' });

describe('date', () => {
  before((done) => {
//  lambdaWrapper.init(liveFunction); // Run the deployed lambda

    done();
  });

  it('response', () => {
    return wrapped.run({}).then((response) => {
      const body = JSON.parse(response.body);

      expect(response).to.not.be.empty;
      expect(response).to.have.property('statusCode');
      expect(response).to.have.property('body');
      expect(response.statusCode).to.equal(200);
      expect(body.message).to.match(/.*\s(Sun|Mon|Tue|Wed|Thu|Fri|Sat)\s(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s[0-3]\d{1}\s\d{4}\./);
    });
  });
});
