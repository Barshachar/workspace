import React, { useEffect, useState } from 'react';
import { createClient } from '@supabase/supabase-js';
import { Button, Dialog, Input } from 'shadcn-ui';

const supabase = createClient(import.meta.env.VITE_SUPABASE_URL!, import.meta.env.VITE_SUPABASE_ANON_KEY!);

type Rule = { id: string; sku: string; discount: number };

export default function PricingPage({ onToast }: { onToast: (t: string) => void }) {
  const [rules, setRules] = useState<Rule[]>([]);
  const [editing, setEditing] = useState<Rule | null>(null);

  useEffect(() => {
    supabase.from('pricing_rules').select('*').then(({ data }) => setRules(data as Rule[]));
  }, []);

  const save = async () => {
    if (!editing) return;
    await supabase.from('pricing_rules').update({ discount: editing.discount }).eq('id', editing.id);
    setEditing(null);
    const { data } = await supabase.from('pricing_rules').select('*');
    setRules(data as Rule[]);
    onToast('Saved');
  };

  return (
    <div className="p-4">
      <h2 className="text-xl mb-4">Pricing Rules</h2>
      <table className="table-auto">
        <thead>
          <tr><th>SKU</th><th>Discount %</th><th></th></tr>
        </thead>
        <tbody>
          {rules.map(r => (
            <tr key={r.id}>
              <td>{r.sku}</td>
              <td>{r.discount}</td>
              <td><Button onClick={() => setEditing(r)}>Edit</Button></td>
            </tr>
          ))}
        </tbody>
      </table>
      {editing && (
        <Dialog onOpenChange={v => !v && setEditing(null)} open>
          <Input type="number" value={editing.discount} onChange={e => setEditing({ ...editing, discount: Number(e.target.value) })} />
          <Button onClick={save}>Save</Button>
        </Dialog>
      )}
    </div>
  );
}
