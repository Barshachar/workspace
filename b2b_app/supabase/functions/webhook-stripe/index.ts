import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@13?target=deno";
import { createClient } from 'supabase';
import { initializeApp, cert, getApps } from 'firebase-admin/app';
import { getMessaging } from 'firebase-admin/messaging';

export async function webhookStripe(req: Request): Promise<Response> {
  const stripe = new Stripe(Deno.env.get('STRIPE_SK')!, { apiVersion: '2023-08-16' });
  const sig = req.headers.get('stripe-signature')!;
  const secret = Deno.env.get('STRIPE_WEBHOOK_SECRET')!;
  const text = await req.text();
  let event;
  try {
    event = stripe.webhooks.constructEvent(text, sig, secret);
  } catch (e) {
    return new Response('invalid signature', { status: 400 });
  }
  const client = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!);
  if (event.type === 'payment_intent.succeeded') {
    const pi: any = event.data.object;
    const orderId = pi.metadata.order_id;
    const customerId = pi.metadata.customer_id;
    await client.from('orders').update({ status: 'paid' }).eq('id', orderId);
    const { data } = await client.functions.invoke('green-invoice', { body: { order_id: orderId } });
    const url = data?.url;
    if (url) {
      await client.from('orders').update({ invoice_url: url }).eq('id', orderId);
    }
    const serviceAccount = JSON.parse(Deno.env.get('FCM_SERVICE_ACCOUNT')!);
    if (!getApps().length) initializeApp({ credential: cert(serviceAccount) });
    await getMessaging().send({ notification: { title: 'Payment received', body: 'תודה' }, topic: `customer_${customerId}` });
  }
  if (event.type === 'payment_intent.payment_failed') {
    const pi: any = event.data.object;
    await client.from('orders').update({ status: 'failed' }).eq('id', pi.metadata.order_id);
  }
  return new Response('ok');
}

serve(webhookStripe);
