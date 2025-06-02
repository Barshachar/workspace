alter table customers add column if not exists role text check (role in ('buyer','sales_rep','admin')) default 'buyer';
