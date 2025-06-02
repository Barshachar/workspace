create table if not exists cart_items (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id),
  product_id uuid references products(id),
  quantity int,
  price numeric(10,2)
);
