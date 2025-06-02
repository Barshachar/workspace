import React, { useEffect, useState } from 'react';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(import.meta.env.VITE_SUPABASE_URL!, import.meta.env.VITE_SUPABASE_ANON_KEY!);

type Order = { id: string; status: string };

export default function OrdersPage({ onToast }: { onToast: (t: string) => void }) {
  const [orders, setOrders] = useState<Order[]>([]);

  useEffect(() => {
    supabase.from('orders').select('id,status').then(({ data }) => setOrders(data as Order[]));
  }, []);

  const update = async (id: string, status: string) => {
    await supabase.from('orders').update({ status }).eq('id', id);
    setOrders(o => o.map(ord => ord.id === id ? { ...ord, status } : ord));
    onToast('Updated');
  };

  return (
    <div className="p-4">
      <h2 className="text-xl mb-4">Orders</h2>
      <table className="table-auto">
        <thead><tr><th>ID</th><th>Status</th></tr></thead>
        <tbody>
          {orders.map(o => (
            <tr key={o.id}>
              <td>{o.id}</td>
              <td>
                <select value={o.status} onChange={e => update(o.id, e.target.value)}>
                  <option value="processing">processing</option>
                  <option value="shipped">shipped</option>
                  <option value="delivered">delivered</option>
                  <option value="paid">paid</option>
                </select>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
