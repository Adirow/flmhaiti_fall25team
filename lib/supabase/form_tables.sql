-- ============================================
-- FORM TEMPLATES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.form_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  clinic_id UUID NOT NULL REFERENCES public.clinics(id) ON DELETE CASCADE,
  department TEXT NOT NULL CHECK (department IN ('dental', 'obgyn', 'general')),
  name TEXT NOT NULL,
  version INTEGER NOT NULL DEFAULT 1,
  description TEXT NOT NULL DEFAULT '',
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for form_templates
CREATE INDEX IF NOT EXISTS idx_form_templates_clinic_id ON public.form_templates(clinic_id);
CREATE INDEX IF NOT EXISTS idx_form_templates_department ON public.form_templates(department);
CREATE INDEX IF NOT EXISTS idx_form_templates_is_active ON public.form_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_form_templates_created_by ON public.form_templates(created_by);

-- ============================================
-- FORM SECTIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.form_sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID NOT NULL REFERENCES public.form_templates(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for form_sections
CREATE INDEX IF NOT EXISTS idx_form_sections_template_id ON public.form_sections(template_id);
CREATE INDEX IF NOT EXISTS idx_form_sections_sort_order ON public.form_sections(sort_order);

-- ============================================
-- FORM QUESTIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.form_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  section_id UUID NOT NULL REFERENCES public.form_sections(id) ON DELETE CASCADE,
  logical_id TEXT NOT NULL,
  label TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('boolean', 'text', 'number', 'date', 'choice', 'multichoice')),
  options JSONB,
  required BOOLEAN NOT NULL DEFAULT false,
  visible_if JSONB,
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for form_questions
CREATE INDEX IF NOT EXISTS idx_form_questions_section_id ON public.form_questions(section_id);
CREATE INDEX IF NOT EXISTS idx_form_questions_logical_id ON public.form_questions(logical_id);
CREATE INDEX IF NOT EXISTS idx_form_questions_type ON public.form_questions(type);
CREATE INDEX IF NOT EXISTS idx_form_questions_is_active ON public.form_questions(is_active);
CREATE INDEX IF NOT EXISTS idx_form_questions_sort_order ON public.form_questions(sort_order);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE public.form_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.form_questions ENABLE ROW LEVEL SECURITY;

-- Form Templates Policies
CREATE POLICY "Allow authenticated users to read form_templates"
  ON public.form_templates FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert form_templates"
  ON public.form_templates FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update form_templates"
  ON public.form_templates FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete form_templates"
  ON public.form_templates FOR DELETE
  TO authenticated
  USING (true);

-- Form Sections Policies
CREATE POLICY "Allow authenticated users to read form_sections"
  ON public.form_sections FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert form_sections"
  ON public.form_sections FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update form_sections"
  ON public.form_sections FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete form_sections"
  ON public.form_sections FOR DELETE
  TO authenticated
  USING (true);

-- Form Questions Policies
CREATE POLICY "Allow authenticated users to read form_questions"
  ON public.form_questions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert form_questions"
  ON public.form_questions FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update form_questions"
  ON public.form_questions FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete form_questions"
  ON public.form_questions FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================

-- Create trigger for form_templates
CREATE TRIGGER update_form_templates_updated_at 
    BEFORE UPDATE ON public.form_templates 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert sample template (uncomment if needed for testing)
-- INSERT INTO public.form_templates (clinic_id, department, name, version, description, created_by)
-- VALUES (
--   'your-clinic-id-here',
--   'dental',
--   'Basic Dental History',
--   1,
--   'Standard dental history questionnaire for new patients',
--   'your-user-id-here'
-- );
