-- =============================================================
-- n8n M-Pesa Course — Database Schema
-- Postgres 14+. Loaded automatically by docker-compose on first boot.
-- =============================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -------------------------------------------------------------
-- mpesa_transactions
-- Core table: one row per STK Push attempt.
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS mpesa_transactions (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    checkout_request_id   TEXT UNIQUE NOT NULL,
    merchant_request_id   TEXT,
    reference             TEXT NOT NULL,
    phone                 VARCHAR(15) NOT NULL,
    amount                NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    status                VARCHAR(20) NOT NULL DEFAULT 'pending'
                             CHECK (status IN ('pending','success','failed','cancelled','timeout')),
    result_code           TEXT,
    result_desc           TEXT,
    mpesa_receipt_number  TEXT UNIQUE,
    transaction_date      TEXT,
    metadata              JSONB DEFAULT '{}'::jsonb,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_mpesa_tx_status      ON mpesa_transactions(status);
CREATE INDEX IF NOT EXISTS idx_mpesa_tx_phone       ON mpesa_transactions(phone);
CREATE INDEX IF NOT EXISTS idx_mpesa_tx_reference   ON mpesa_transactions(reference);
CREATE INDEX IF NOT EXISTS idx_mpesa_tx_created_at  ON mpesa_transactions(created_at DESC);

-- -------------------------------------------------------------
-- mpesa_callbacks
-- Audit trail: raw callback payloads from Safaricom (never mutate).
-- -------------------------------------------------------------
CREATE TABLE IF NOT EXISTS mpesa_callbacks (
    id                   BIGSERIAL PRIMARY KEY,
    checkout_request_id  TEXT,
    received_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    headers              JSONB,
    body                 JSONB NOT NULL,
    source_ip            INET
);

CREATE INDEX IF NOT EXISTS idx_mpesa_cb_checkout ON mpesa_callbacks(checkout_request_id);

-- -------------------------------------------------------------
-- Convenience view: daily totals
-- -------------------------------------------------------------
CREATE OR REPLACE VIEW mpesa_daily_summary AS
SELECT
    DATE(created_at AT TIME ZONE 'Africa/Nairobi') AS day,
    status,
    COUNT(*)                 AS tx_count,
    COALESCE(SUM(amount), 0) AS total_amount
FROM mpesa_transactions
GROUP BY 1, 2
ORDER BY 1 DESC, 2;

-- -------------------------------------------------------------
-- Auto-update updated_at
-- -------------------------------------------------------------
CREATE OR REPLACE FUNCTION trg_set_updated_at() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS mpesa_tx_updated_at ON mpesa_transactions;
CREATE TRIGGER mpesa_tx_updated_at
    BEFORE UPDATE ON mpesa_transactions
    FOR EACH ROW EXECUTE FUNCTION trg_set_updated_at();

