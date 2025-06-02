import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';

serve(async (req) => {
  const { sku, customer_id, base_price } = await req.json();
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceRole = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const client = createClient(supabaseUrl, serviceRole);

  const { data: rule } = await client
    .from('pricing_rules')
    .select('*')
    .eq('sku', sku)
    .lte('valid_from', new Date().toISOString())
    .gte('valid_to', new Date().toISOString())
    .single();

  let price = base_price;
  if (rule) {
    price = price * (1 - Number(rule.discount) / 100);
  }

  return new Response(JSON.stringify({ price }), {
    headers: { 'Content-Type': 'application/json' },
  });
});
