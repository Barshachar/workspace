import React, { useState } from 'react';
import { createClient } from '@supabase/supabase-js';

const supabase = createClient(import.meta.env.VITE_SUPABASE_URL, import.meta.env.VITE_SUPABASE_ANON_KEY);

export default function Login({ onLogin }: { onLogin: () => void }) {
  const [email, setEmail] = useState('');
  const [token, setToken] = useState('');
  const [sent, setSent] = useState(false);
  const [loading, setLoading] = useState(false);

  const send = async () => {
    setLoading(true);
    await supabase.auth.signInWithOtp({ email });
    setLoading(false);
    setSent(true);
  };

  const verify = async () => {
    setLoading(true);
    const { data } = await supabase.auth.verifyOtp({ email, token, type: 'email' });
    setLoading(false);
    if (data?.user) onLogin();
  };

  return (
    <div>
      <input value={email} onChange={e => setEmail(e.target.value)} placeholder="email" />
      {!sent && <button onClick={send} disabled={loading}>Send</button>}
      {sent && (
        <div>
          <input value={token} onChange={e => setToken(e.target.value)} placeholder="code" />
          <button onClick={verify} disabled={loading}>Verify</button>
        </div>
      )}
      {loading && <div>...</div>}
    </div>
  );
}
