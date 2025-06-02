import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';
import { initializeApp, cert, getApps, getMessaging } from 'firebase-admin/app';
import { getMessaging as getFcm } from 'firebase-admin/messaging';

export async function orderCreated(req: Request): Promise<Response> {
  const { record } = await req.json();
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceRole = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const client = createClient(supabaseUrl, serviceRole);

  const { data: prod } = await client
    .from('products')
    .select('stock')
    .eq('id', record.product_id)
    .single();
  if (prod) {
    await client
      .from('products')
      .update({ stock: (prod.stock as number) - record.qty })
      .eq('id', record.product_id);
  }

  const { data: order } = await client
    .from('orders')
    .select('customer_id')
    .eq('id', record.order_id)
    .single();

  const serviceAccount = JSON.parse(Deno.env.get('FCM_SERVICE_ACCOUNT')!);
  if (!getApps().length) {
    initializeApp({ credential: cert(serviceAccount) });
  }

  if (order) {
    await getFcm().send({
      notification: { title: 'הזמנה חדשה', body: 'תודה על ההזמנה' },
      topic: `customer_${order.customer_id}`,
    });
  }

  return new Response('ok');
}

serve(orderCreated);
