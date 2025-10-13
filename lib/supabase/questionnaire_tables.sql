-- ============================================
-- QUESTIONNAIRE SESSIONS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.questionnaire_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_id UUID NOT NULL REFERENCES public.patients(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES public.form_templates(id) ON DELETE CASCADE,
  template_name TEXT NOT NULL,
  template_version INTEGER NOT NULL,
  department TEXT NOT NULL CHECK (department IN ('dental', 'obgyn', 'general')),
  status TEXT NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'submitted', 'archived')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  submitted_at TIMESTAMPTZ,
  created_by UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  clinic_id UUID NOT NULL REFERENCES public.clinics(id) ON DELETE CASCADE
);

-- Create indexes for questionnaire_sessions
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_patient_id ON public.questionnaire_sessions(patient_id);
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_template_id ON public.questionnaire_sessions(template_id);
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_status ON public.questionnaire_sessions(status);
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_department ON public.questionnaire_sessions(department);
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_clinic_id ON public.questionnaire_sessions(clinic_id);
CREATE INDEX IF NOT EXISTS idx_questionnaire_sessions_started_at ON public.questionnaire_sessions(started_at);

-- ============================================
-- QUESTIONNAIRE ANSWERS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS public.questionnaire_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.questionnaire_sessions(id) ON DELETE CASCADE,
  question_logical_id TEXT NOT NULL,
  question_label TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('boolean', 'text', 'number', 'date', 'choice', 'multichoice')),
  answer_value JSONB,
  answered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  
  -- Ensure unique answer per session + question
  UNIQUE(session_id, question_logical_id)
);

-- Create indexes for questionnaire_answers
CREATE INDEX IF NOT EXISTS idx_questionnaire_answers_session_id ON public.questionnaire_answers(session_id);
CREATE INDEX IF NOT EXISTS idx_questionnaire_answers_logical_id ON public.questionnaire_answers(question_logical_id);
CREATE INDEX IF NOT EXISTS idx_questionnaire_answers_type ON public.questionnaire_answers(question_type);
CREATE INDEX IF NOT EXISTS idx_questionnaire_answers_answered_at ON public.questionnaire_answers(answered_at);

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE public.questionnaire_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questionnaire_answers ENABLE ROW LEVEL SECURITY;

-- Questionnaire Sessions Policies
CREATE POLICY "Allow authenticated users to read questionnaire_sessions"
  ON public.questionnaire_sessions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert questionnaire_sessions"
  ON public.questionnaire_sessions FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update questionnaire_sessions"
  ON public.questionnaire_sessions FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete questionnaire_sessions"
  ON public.questionnaire_sessions FOR DELETE
  TO authenticated
  USING (true);

-- Questionnaire Answers Policies
CREATE POLICY "Allow authenticated users to read questionnaire_answers"
  ON public.questionnaire_answers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert questionnaire_answers"
  ON public.questionnaire_answers FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update questionnaire_answers"
  ON public.questionnaire_answers FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete questionnaire_answers"
  ON public.questionnaire_answers FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- TRIGGERS FOR SUBMITTED_AT
-- ============================================

-- Function to update submitted_at when status changes to 'submitted'
CREATE OR REPLACE FUNCTION update_questionnaire_submitted_at()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.status = 'submitted' AND OLD.status != 'submitted' THEN
    NEW.submitted_at = NOW();
  ELSIF NEW.status != 'submitted' THEN
    NEW.submitted_at = NULL;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for questionnaire_sessions
CREATE TRIGGER trigger_update_questionnaire_submitted_at
  BEFORE UPDATE ON public.questionnaire_sessions
  FOR EACH ROW
  EXECUTE FUNCTION update_questionnaire_submitted_at();

-- ============================================
-- USEFUL VIEWS
-- ============================================

-- View for session summary with answer counts
CREATE OR REPLACE VIEW public.questionnaire_session_summary AS
SELECT 
  qs.*,
  COUNT(qa.id) as answered_questions,
  COUNT(qa.id) FILTER (WHERE qa.answer_value IS NOT NULL AND qa.answer_value != 'null'::jsonb) as completed_questions,
  p.name as patient_name,
  p.phone as patient_phone
FROM public.questionnaire_sessions qs
LEFT JOIN public.questionnaire_answers qa ON qs.id = qa.session_id
LEFT JOIN public.patients p ON qs.patient_id = p.id
GROUP BY qs.id, p.name, p.phone;

-- ============================================
-- SAMPLE DATA (Optional - for testing)
-- ============================================

-- Insert sample session (uncomment if needed for testing)
-- INSERT INTO public.questionnaire_sessions (
--   patient_id, 
--   template_id, 
--   template_name, 
--   template_version, 
--   department, 
--   created_by, 
--   clinic_id
-- ) VALUES (
--   'your-patient-id-here',
--   'your-template-id-here',
--   'Basic Dental History',
--   1,
--   'dental',
--   'your-user-id-here',
--   'your-clinic-id-here'
-- );
