import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from 'supabase';

serve(async () => {
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
  const serviceRole = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
  const client = createClient(supabaseUrl, serviceRole);
  const { data } = await client
    .from('products')
    .select('id,name,stock')
    .lt('stock', 3);
  return new Response(JSON.stringify(data ?? []), {
    headers: { 'Content-Type': 'application/json' },
  });
});
