-- Billing Module Migration
-- Creates invoices, line items, payments, and supporting automation/RLS policies

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'billing_invoice_status') THEN
        CREATE TYPE billing_invoice_status AS ENUM (
            'draft',
            'sent',
            'partial',
            'paid',
            'void'
        );
    END IF;
END;
$$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'billing_payment_method') THEN
        CREATE TYPE billing_payment_method AS ENUM (
            'cash',
            'card',
            'check',
            'mobile_money',
            'other'
        );
    END IF;
END;
$$;

CREATE TABLE IF NOT EXISTS billing_invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    encounter_id UUID REFERENCES encounters(id) ON DELETE SET NULL,
    invoice_number TEXT NOT NULL,
    status billing_invoice_status NOT NULL DEFAULT 'draft',
    currency TEXT NOT NULL DEFAULT 'USD',
    subtotal NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (subtotal >= 0),
    discount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
    tax NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (tax >= 0),
    total NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (total >= 0),
    balance_due NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (balance_due >= 0),
    due_date TIMESTAMPTZ,
    notes TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    updated_by UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (clinic_id, invoice_number),
    CONSTRAINT billing_invoices_balance_check CHECK (balance_due <= total),
    CONSTRAINT billing_invoices_id_clinic UNIQUE (id, clinic_id)
);

CREATE TABLE IF NOT EXISTS billing_invoice_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL REFERENCES billing_invoices(id) ON DELETE CASCADE,
    code TEXT,
    description TEXT NOT NULL,
    quantity NUMERIC(10,2) NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (unit_price >= 0),
    discount NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (discount >= 0),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS billing_payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID NOT NULL,
    clinic_id UUID NOT NULL REFERENCES clinics(id) ON DELETE CASCADE,
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    method billing_payment_method NOT NULL DEFAULT 'cash',
    reference TEXT,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    notes TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT billing_payments_invoice_clinic_fk
        FOREIGN KEY (invoice_id, clinic_id) REFERENCES billing_invoices(id, clinic_id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_billing_invoices_clinic ON billing_invoices(clinic_id);
CREATE INDEX IF NOT EXISTS idx_billing_invoices_patient ON billing_invoices(patient_id);
CREATE INDEX IF NOT EXISTS idx_billing_invoices_status ON billing_invoices(status);
CREATE INDEX IF NOT EXISTS idx_billing_invoice_items_invoice ON billing_invoice_items(invoice_id);
CREATE INDEX IF NOT EXISTS idx_billing_payments_invoice ON billing_payments(invoice_id);
CREATE INDEX IF NOT EXISTS idx_billing_payments_clinic ON billing_payments(clinic_id);

ALTER TABLE billing_invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_invoice_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE billing_payments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Clinic members view invoices" ON billing_invoices
FOR SELECT
USING (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid);

CREATE POLICY "Clinic members manage invoices" ON billing_invoices
FOR ALL
USING (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid)
WITH CHECK (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid);

CREATE POLICY "Clinic members view invoice items" ON billing_invoice_items
FOR SELECT
USING (
    EXISTS (
        SELECT 1
        FROM billing_invoices bi
        WHERE bi.id = invoice_id
          AND bi.clinic_id = (auth.jwt() ->> 'clinic_id')::uuid
    )
);

CREATE POLICY "Clinic members manage invoice items" ON billing_invoice_items
FOR ALL
USING (
    EXISTS (
        SELECT 1
        FROM billing_invoices bi
        WHERE bi.id = invoice_id
          AND bi.clinic_id = (auth.jwt() ->> 'clinic_id')::uuid
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1
        FROM billing_invoices bi
        WHERE bi.id = invoice_id
          AND bi.clinic_id = (auth.jwt() ->> 'clinic_id')::uuid
    )
);

CREATE POLICY "Clinic members view payments" ON billing_payments
FOR SELECT
USING (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid);

CREATE POLICY "Clinic members manage payments" ON billing_payments
FOR ALL
USING (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid)
WITH CHECK (clinic_id = (auth.jwt() ->> 'clinic_id')::uuid);

-- Utility functions & triggers ------------------------------------------------

CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.recalculate_billing_invoice(target_invoice_id UUID)
RETURNS VOID AS $$
DECLARE
    invoice_record billing_invoices%ROWTYPE;
    line_subtotal NUMERIC(12,2) := 0;
    line_discount NUMERIC(12,2) := 0;
    payment_total NUMERIC(12,2) := 0;
    computed_total NUMERIC(12,2);
    computed_balance NUMERIC(12,2);
    computed_status billing_invoice_status;
BEGIN
    IF target_invoice_id IS NULL THEN
        RETURN;
    END IF;

    SELECT *
    INTO invoice_record
    FROM billing_invoices
    WHERE id = target_invoice_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RETURN;
    END IF;

    SELECT
        COALESCE(SUM(quantity * unit_price), 0),
        COALESCE(SUM(discount), 0)
    INTO line_subtotal, line_discount
    FROM billing_invoice_items
    WHERE invoice_id = target_invoice_id;

    SELECT COALESCE(SUM(amount), 0)
    INTO payment_total
    FROM billing_payments
    WHERE invoice_id = target_invoice_id;

    computed_total := GREATEST(line_subtotal - line_discount + COALESCE(invoice_record.tax, 0), 0);
    computed_balance := GREATEST(computed_total - payment_total, 0);

    computed_status := CASE
        WHEN invoice_record.status = 'void' THEN 'void'
        WHEN computed_balance = 0 AND computed_total > 0 THEN 'paid'
        WHEN payment_total > 0 THEN 'partial'
        ELSE invoice_record.status
    END;

    UPDATE billing_invoices
    SET subtotal = line_subtotal,
        discount = line_discount,
        total = computed_total,
        balance_due = computed_balance,
        status = computed_status
    WHERE id = target_invoice_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.trigger_recalculate_invoice()
RETURNS TRIGGER AS $$
DECLARE
    target_invoice_id UUID;
BEGIN
    target_invoice_id := COALESCE(NEW.invoice_id, OLD.invoice_id);

    IF target_invoice_id IS NOT NULL THEN
        PERFORM public.recalculate_billing_invoice(target_invoice_id);
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.set_billing_payment_clinic()
RETURNS TRIGGER AS $$
DECLARE
    derived_clinic UUID;
BEGIN
    SELECT clinic_id
    INTO derived_clinic
    FROM billing_invoices
    WHERE id = NEW.invoice_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Invoice % not found for payment enforcement', NEW.invoice_id;
    END IF;

    NEW.clinic_id := derived_clinic;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER billing_invoices_set_updated_at
BEFORE UPDATE ON billing_invoices
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER billing_invoice_items_recalculate
AFTER INSERT OR UPDATE OR DELETE ON billing_invoice_items
FOR EACH ROW
EXECUTE FUNCTION public.trigger_recalculate_invoice();

CREATE TRIGGER billing_payments_set_clinic
BEFORE INSERT OR UPDATE ON billing_payments
FOR EACH ROW
EXECUTE FUNCTION public.set_billing_payment_clinic();

CREATE TRIGGER billing_payments_recalculate
AFTER INSERT OR UPDATE OR DELETE ON billing_payments
FOR EACH ROW
EXECUTE FUNCTION public.trigger_recalculate_invoice();
