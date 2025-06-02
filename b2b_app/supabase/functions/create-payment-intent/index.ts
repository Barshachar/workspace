import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import Stripe from "https://esm.sh/stripe@13?target=deno";

export async function createPaymentIntent(req: Request): Promise<Response> {
  try {
    const { order_id, amount, currency = 'usd', customer_id } = await req.json();
    const stripe = new Stripe(Deno.env.get('STRIPE_SK')!, { apiVersion: '2023-08-16' });
    const intent = await stripe.paymentIntents.create({
      amount,
      currency,
      metadata: { order_id, customer_id },
    });
    return new Response(JSON.stringify({ client_secret: intent.client_secret }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (e) {
    const message = e instanceof Error ? e.message : 'unknown';
    return new Response(JSON.stringify({ error: message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }
}

serve(createPaymentIntent);
