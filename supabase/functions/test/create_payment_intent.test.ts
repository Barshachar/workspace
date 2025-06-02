import { createPaymentIntent } from '../create-payment-intent/index.ts';

describe('create-payment-intent', () => {
  it('exports function', () => {
    expect(typeof createPaymentIntent).toBe('function');
  });
});
