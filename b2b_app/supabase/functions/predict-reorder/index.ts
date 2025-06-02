import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';

function badRequest(msg: string) {
  console.error(msg);
  return new Response(JSON.stringify({ error: msg }), {
    status: 400,
    headers: { 'Content-Type': 'application/json' },
  });
}

export async function predictReorder(): Promise<Response> {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const serviceRole = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    if (!supabaseUrl || !serviceRole) {
      return badRequest('env missing');
    }
    const client = createClient(supabaseUrl, serviceRole);

    const { data: orders, error } = await client
      .from('orders')
      .select('customer_id, created_at, order_items(product_id)')
      .order('created_at', { ascending: false });
    if (error) return badRequest(error.message);

  const now = Date.now();
  const seen = new Set<string>();
  for (const o of orders ?? []) {
    const date = new Date(o.created_at as string);
    const diff = (now - date.getTime()) / 86400000;
    for (const item of o.order_items ?? []) {
      const key = `${o.customer_id}_${item.product_id}`;
      if (!seen.has(key)) {
        seen.add(key);
        if (diff > 30) {
          await client.from('notifications').insert({
            customer_id: o.customer_id,
            message: `הגיע הזמן לחדש מלאי של ${item.product_id}`,
          });
        }
      }
    }
  }
    return new Response('ok');
  } catch (e) {
    return badRequest((e as Error).message);
  }
}

serve(predictReorder);
