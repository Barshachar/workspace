alter table orders
  partition by range (created_at);

create table if not exists orders_y2025
  partition of orders for values from ('2025-01-01') to ('2026-01-01');
