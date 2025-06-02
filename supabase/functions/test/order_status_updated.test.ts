import { orderStatusUpdated } from '../order-status-updated/index.ts';

describe('order-status-updated', () => {
  it('exports handler', () => {
    expect(typeof orderStatusUpdated).toBe('function');
  });
});
