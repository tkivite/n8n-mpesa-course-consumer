-- =============================================================
-- Supabase migration (same as schema.sql + RLS + anon-safe view)
-- Run in Supabase SQL Editor.
-- =============================================================

-- Reuse the main schema
\i schema.sql

-- -------------------------------------------------------------
-- Row-Level Security (Supabase)
-- -------------------------------------------------------------
ALTER TABLE mpesa_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE mpesa_callbacks    ENABLE ROW LEVEL SECURITY;

-- Only service_role (used by n8n) can read/write
CREATE POLICY "service_role full access tx"
    ON mpesa_transactions FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

CREATE POLICY "service_role full access cb"
    ON mpesa_callbacks FOR ALL
    USING (auth.role() = 'service_role')
    WITH CHECK (auth.role() = 'service_role');

-- Optional: let authenticated users read their own transactions by phone
-- CREATE POLICY "users read own tx"
--     ON mpesa_transactions FOR SELECT
--     USING (phone = (auth.jwt() ->> 'phone'));

