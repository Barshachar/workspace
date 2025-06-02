import React, { useEffect, useState } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { createClient } from '@supabase/supabase-js';
import PricingPage from './pricing';
import Login from './login';
import OrdersPage from './orders';
import './index.css';

const supabase = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_ANON_KEY);

function App() {
  const [lowStock, setLowStock] = useState<number>(0);
  const [logged, setLogged] = useState(false);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState('');
  useEffect(() => {
    const { data: sub } = supabase.auth.onAuthStateChange((_e, s) => {
      setLogged(!!s); setLoading(false);
    });
    fetch('/functions/v1/low-stock').then(r => r.json()).then(d => setLowStock(d.length));
    return () => { sub.subscription.unsubscribe(); };
  }, []);
  if (loading) return <div className="p-4">Loading...</div>;
  if (!logged) return <Login onLogin={() => setLogged(true)} />;
  return (
    <BrowserRouter>
      {lowStock > 0 && <div className="bg-orange-500 text-white p-2">Low stock: {lowStock}</div>}
      {toast && <div className="fixed top-2 right-2 bg-green-600 text-white p-2">{toast}</div>}
      <nav className="p-2 flex gap-4">
        <Link to="/pricing">Pricing</Link> | <Link to="/orders">Orders</Link>
      </nav>
      <Routes>
        <Route path="/pricing" element={<PricingPage onToast={setToast} />} />
        <Route path="/orders" element={<OrdersPage onToast={setToast} />} />
        <Route path="*" element={<div>Admin Dashboard</div>} />
      </Routes>
    </BrowserRouter>
  );
}

createRoot(document.getElementById('root')!).render(<App />);
