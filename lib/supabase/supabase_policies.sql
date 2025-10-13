-- Row Level Security Policies for Dental EMR
-- This file contains all RLS policies for the modular Dental EMR system

-- ============================================
-- ENABLE ROW LEVEL SECURITY
-- ============================================
ALTER TABLE public.clinics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_history_core ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.medical_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.encounters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.odontogram_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;

-- ============================================
-- CLINICS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read clinics"
  ON public.clinics FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert clinics"
  ON public.clinics FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update clinics"
  ON public.clinics FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete clinics"
  ON public.clinics FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- USERS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read users"
  ON public.users FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow users to insert their own profile"
  ON public.users FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow users to update their own profile"
  ON public.users FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete users"
  ON public.users FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- PATIENTS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read patients"
  ON public.patients FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert patients"
  ON public.patients FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update patients"
  ON public.patients FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete patients"
  ON public.patients FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- MEDICAL HISTORY CORE POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read medical history"
  ON public.medical_history_core FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert medical history"
  ON public.medical_history_core FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update medical history"
  ON public.medical_history_core FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete medical history"
  ON public.medical_history_core FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- MEDICAL QUESTIONS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read medical questions"
  ON public.medical_questions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert medical questions"
  ON public.medical_questions FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update medical questions"
  ON public.medical_questions FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete medical questions"
  ON public.medical_questions FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- MEDICAL ANSWERS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read medical answers"
  ON public.medical_answers FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert medical answers"
  ON public.medical_answers FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update medical answers"
  ON public.medical_answers FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete medical answers"
  ON public.medical_answers FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- ENCOUNTERS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read encounters"
  ON public.encounters FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert encounters"
  ON public.encounters FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update encounters"
  ON public.encounters FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete encounters"
  ON public.encounters FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- ODONTOGRAM ITEMS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read odontogram items"
  ON public.odontogram_items FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert odontogram items"
  ON public.odontogram_items FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update odontogram items"
  ON public.odontogram_items FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete odontogram items"
  ON public.odontogram_items FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- PROGRESS NOTES POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read progress notes"
  ON public.progress_notes FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert progress notes"
  ON public.progress_notes FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update progress notes"
  ON public.progress_notes FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete progress notes"
  ON public.progress_notes FOR DELETE
  TO authenticated
  USING (true);

-- ============================================
-- APPOINTMENTS POLICIES
-- ============================================
CREATE POLICY "Allow authenticated users to read appointments"
  ON public.appointments FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Allow authenticated users to insert appointments"
  ON public.appointments FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to update appointments"
  ON public.appointments FOR UPDATE
  TO authenticated
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow authenticated users to delete appointments"
  ON public.appointments FOR DELETE
  TO authenticated
  USING (true);
