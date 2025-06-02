import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';

function bad(msg: string) {
  console.error(msg);
  return new Response(JSON.stringify({ error: msg }), {
    status: 400,
    headers: { 'Content-Type': 'application/json' },
  });
}

serve(async (req) => {
  try {
    const body = await req.json().catch(() => null);
    const customer_id = body?.customer_id as string | undefined;
    if (!customer_id) return bad('missing customer_id');
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRole = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRole) return bad('env missing');
    const client = createClient(supabaseUrl, serviceRole);
    const { data: last, error } = await client
      .from('orders')
      .select('id, order_items(product_id, products(category))')
      .eq('customer_id', customer_id)
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle();
    if (error) return bad(error.message);
    const category = last?.order_items?.[0]?.products?.category;
    if (!category) return new Response(JSON.stringify([]), { headers: { 'Content-Type': 'application/json' } });
    const { data, error: err } = await client
      .from('products')
      .select('*')
      .eq('category', category)
      .neq('is_active', false)
      .limit(5);
    if (err) return bad(err.message);
    return new Response(JSON.stringify(data ?? []), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (e) {
    return bad((e as Error).message);
  }
});
