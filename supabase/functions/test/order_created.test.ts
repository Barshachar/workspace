import { orderCreated } from '../order-created/index.ts';

describe('order-created', () => {
  it('exports handler', () => {
    expect(typeof orderCreated).toBe('function');
  });
});
