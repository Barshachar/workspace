import { webhookStripe } from '../webhook-stripe/index.ts';

describe('webhook-stripe', () => {
  it('exports handler', () => {
    expect(typeof webhookStripe).toBe('function');
  });
});
