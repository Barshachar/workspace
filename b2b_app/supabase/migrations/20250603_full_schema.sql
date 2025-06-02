-- customers with credit limit
create table if not exists customers (
  id uuid primary key default gen_random_uuid(),
  company_name text,
  contact_name text,
  email text unique,
  phone text,
  credit_limit numeric(10,2) default 0,
  created_at timestamp with time zone default now()
);

-- products
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  sku text unique,
  name text,
  category text,
  price numeric(10,2),
  image_url text,
  stock int,
  is_active boolean default true,
  created_at timestamp with time zone default now()
);

create index if not exists idx_products_active on products(is_active);
create index if not exists idx_products_name_trgm on products using gin(name gin_trgm_ops);

-- orders
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  status text default 'processing',
  total numeric(10,2),
  invoice_url text,
  created_at timestamp with time zone default now()
);
create index if not exists idx_orders_created on orders(created_at);

-- order_items
create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid references orders(id),
  product_id uuid references products(id),
  qty int,
  price numeric(10,2)
);

-- pricing rules
create table if not exists pricing_rules (
  id uuid primary key default gen_random_uuid(),
  sku text,
  conditions jsonb,
  discount numeric(5,2),
  valid_from date,
  valid_to date
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid references customers(id),
  message text,
  created_at timestamp with time zone default now()
);

alter table orders enable row level security;
alter table order_items enable row level security;

create policy "customer orders" on orders for select using (auth.uid() = customer_id);
create policy "insert own order" on orders for insert with check (auth.uid() = customer_id);
create policy "customer items" on order_items for select using (
  exists(select 1 from orders o where o.id = order_id and o.customer_id = auth.uid())
);
create policy "insert order item" on order_items for insert with check (
  exists(select 1 from orders o where o.id = order_id and o.customer_id = auth.uid())
);
