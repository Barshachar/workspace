import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';
import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

export async function orderStatusUpdated(req: Request): Promise<Response> {
  const { order_id, status, customer_id, sales_rep } = await req.json();
  const client = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);
  await client.from('orders').update({ status }).eq('id', order_id);
  const serviceAccount = JSON.parse(Deno.env.get('FCM_SERVICE_ACCOUNT')!);
  if (!getApps().length) initializeApp({ credential: cert(serviceAccount) });
  await getMessaging().send({ notification: { title: 'Order Update', body: status }, topic: `customer_${customer_id}` });
  if (sales_rep) {
    await getMessaging().send({ notification: { title: 'Order Update', body: status }, topic: `rep_${sales_rep}` });
  }
  return new Response('ok');
}

serve(orderStatusUpdated);
