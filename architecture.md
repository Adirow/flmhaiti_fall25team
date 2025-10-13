# Dental EMR System Architecture

## Overview
A modular, scalable Dental Electronic Medical Records (EMR) system built with Flutter and Supabase. The system is designed for multi-tenant clinics with role-based access control and future extensibility.

## Core Principles
1. **Multi-tenant isolation**: All tables include `clinic_id` for data separation
2. **Role-based security**: Supabase RLS policies per role (admin, dentist, assistant, clerk)
3. **Modular design**: New modules can be added without modifying existing schema
4. **Audit trail**: All mutations tracked in `audit_logs`
5. **UUID primary keys**: For distributed systems compatibility
6. **JSONB flexibility**: Extended fields stored as JSONB for future needs

## Database Schema (Supabase)

### Core Tables

#### 1. clinics
- `id` (uuid, PK)
- `name` (text)
- `address` (text)
- `phone` (text)
- `created_at` (timestamp)

#### 2. profiles (Supabase Auth integration)
- `id` (uuid, PK, FK to auth.users)
- `clinic_id` (uuid, FK to clinics)
- `email` (text)
- `full_name` (text)
- `role` (enum: admin, dentist, assistant, clerk)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 3. patients
- `id` (uuid, PK)
- `clinic_id` (uuid, FK to clinics)
- `name` (text)
- `gender` (enum: male, female, other)
- `dob` (date)
- `phone` (text)
- `address` (text)
- `blood_pressure` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 4. medical_history_core
- `id` (uuid, PK)
- `patient_id` (uuid, FK to patients)
- `allergies` (text)
- `has_diabetes` (boolean)
- `has_heart_issues` (boolean)
- `is_pregnant` (boolean)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 5. medical_questions
- `id` (uuid, PK)
- `clinic_id` (uuid, FK to clinics)
- `question_text` (text)
- `question_type` (enum: text, boolean, multiple_choice)
- `options` (jsonb, nullable)
- `is_active` (boolean)
- `display_order` (int)
- `created_at` (timestamp)

#### 6. medical_answers
- `id` (uuid, PK)
- `patient_id` (uuid, FK to patients)
- `question_id` (uuid, FK to medical_questions)
- `answer_text` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 7. encounters
- `id` (uuid, PK)
- `patient_id` (uuid, FK to patients)
- `provider_id` (uuid, FK to profiles)
- `clinic_id` (uuid, FK to clinics)
- `exam_type` (text)
- `chief_complaint` (text)
- `notes` (text)
- `visit_date` (timestamp)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 8. odontogram_items
- `id` (uuid, PK)
- `encounter_id` (uuid, FK to encounters)
- `tooth_code` (text)
- `diagnoses` (jsonb array)
- `treatment_plan` (jsonb array)
- `notes` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 9. progress_notes
- `id` (uuid, PK)
- `encounter_id` (uuid, FK to encounters)
- `anesthesia_type` (text)
- `dose` (text)
- `materials_used` (text)
- `complications` (text)
- `follow_up_plan` (text)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 10. appointments
- `id` (uuid, PK)
- `patient_id` (uuid, FK to patients)
- `provider_id` (uuid, FK to profiles)
- `clinic_id` (uuid, FK to clinics)
- `reason` (text)
- `start_time` (timestamp)
- `end_time` (timestamp)
- `status` (enum: scheduled, confirmed, in_progress, completed, cancelled)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### 11. audit_logs
- `id` (uuid, PK)
- `table_name` (text)
- `record_id` (uuid)
- `action` (enum: insert, update, delete)
- `changed_by` (uuid, FK to profiles)
- `changed_at` (timestamp)
- `old_data` (jsonb)
- `new_data` (jsonb)

### Supabase Views (For Joined Data)

#### v_patient_medical_history
Combines patients + medical_history_core + medical_answers

#### v_encounters_with_provider
Combines encounters + profiles (provider info)

#### v_appointments_with_details
Combines appointments + patients + profiles

## Flutter App Structure

### Directory Layout
```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── clinic.dart
│   ├── user_profile.dart
│   ├── patient.dart
│   ├── medical_history_core.dart
│   ├── medical_question.dart
│   ├── medical_answer.dart
│   ├── encounter.dart
│   ├── odontogram_item.dart
│   ├── progress_note.dart
│   └── appointment.dart
├── services/
│   ├── supabase_service.dart
│   ├── patient_service.dart
│   ├── medical_history_service.dart
│   ├── encounter_service.dart
│   ├── odontogram_service.dart
│   ├── progress_note_service.dart
│   ├── appointment_service.dart
│   └── auth_service.dart
├── screens/
│   ├── auth/
│   │   └── login_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── patients/
│   │   ├── patient_list_screen.dart
│   │   ├── patient_detail_screen.dart
│   │   └── add_patient_screen.dart
│   ├── medical_history/
│   │   └── medical_history_screen.dart
│   ├── encounters/
│   │   ├── encounter_screen.dart
│   │   └── add_encounter_screen.dart
│   ├── odontogram/
│   │   └── odontogram_screen.dart
│   ├── progress_notes/
│   │   └── progress_note_screen.dart
│   └── appointments/
│       ├── appointments_screen.dart
│       └── add_appointment_screen.dart
└── widgets/
    ├── custom_button.dart
    ├── custom_text_field.dart
    ├── patient_card.dart
    ├── appointment_card.dart
    └── tooth_widget.dart
```

## Implementation Plan

### Phase 1: Setup & Models (Current Phase)
1. ✅ Create architecture document
2. Create all data models with `toJson`, `fromJson`, `copyWith` methods
3. Set up theme with modern medical-appropriate colors
4. Update main.dart with navigation structure

### Phase 2: Supabase Integration (Next Phase)
1. User will connect Supabase via Dreamflow panel
2. Generate SQL migrations for all tables
3. Set up RLS policies
4. Create database views
5. Implement audit log triggers

### Phase 3: Core Services
1. Implement SupabaseService (singleton with connection)
2. Create service classes for each model
3. Implement CRUD operations
4. Add error handling and logging

### Phase 4: Authentication & Dashboard
1. Login screen with Supabase Auth
2. Dashboard with role-based navigation
3. User profile management

### Phase 5: Patient Management
1. Patient list with search/filter
2. Patient detail view
3. Add/edit patient forms
4. Medical history integration

### Phase 6: Medical History (Hybrid Model)
1. Load fixed + dynamic questions
2. Save fixed fields to core table
3. Save dynamic answers to answers table
4. Display combined view

### Phase 7: Encounters & Clinical Features
1. Encounter creation and listing
2. Odontogram (tooth map) interface
3. Progress notes linked to encounters

### Phase 8: Appointments
1. Calendar view
2. Schedule appointments
3. Status management
4. Notifications (future)

### Phase 9: Testing & Refinement
1. Compile and fix errors
2. Test all CRUD operations
3. Test RLS policies
4. UI/UX refinement

## Design Guidelines

### Color Palette (Medical Professional Theme)
- **Primary**: Teal/Cyan (#00ACC1) - Trust, cleanliness
- **Secondary**: Deep Blue (#1565C0) - Professional, calm
- **Accent**: Coral (#FF7043) - Warmth, approachable
- **Success**: Green (#43A047)
- **Warning**: Amber (#FFA726)
- **Error**: Red (#E53935)
- **Background**: Off-white (#F5F7FA)
- **Surface**: White (#FFFFFF)
- **Text Primary**: Dark Gray (#2C3E50)
- **Text Secondary**: Medium Gray (#607D8B)

### Typography
- **Primary Font**: Inter (modern, readable)
- **Headers**: 24-32px, SemiBold
- **Body**: 14-16px, Regular
- **Labels**: 12-14px, Medium

### Spacing
- **Card Padding**: 20px
- **Section Spacing**: 24px
- **Element Spacing**: 16px
- **Tight Spacing**: 8px

### UI Components
- Rounded corners (12-16px)
- Subtle shadows
- Clean, minimal borders
- Generous white space
- Large touch targets (48px min)

## Future Extensibility

### Ready for Plug-and-Play Modules
1. **Prescriptions**: New table with `encounter_id` FK
2. **Lab Results**: New table with `patient_id` FK
3. **Billing/Invoices**: New table with `patient_id` + `encounter_id`
4. **Attachments**: Supabase Storage with metadata table
5. **Notifications**: New table + real-time subscriptions
6. **Reports/Analytics**: New views and aggregation functions
7. **Treatment Plans**: Enhanced odontogram with scheduling
8. **Insurance Management**: New module with claims tracking

### No Schema Changes Required
- All new modules add new tables
- Existing tables remain unchanged
- Foreign keys link to core entities
- JSONB fields allow flexible data structures

## Security Model

### Row Level Security (RLS) Policies

#### Clinic Isolation
```sql
-- All queries automatically filter by clinic_id
CREATE POLICY clinic_isolation ON patients
  FOR ALL USING (clinic_id = auth.jwt() ->> 'clinic_id');
```

#### Role-Based Access
- **Admin**: Full access to all clinic data
- **Dentist**: Read/write patients, encounters, prescriptions
- **Assistant**: Read patients, write appointments, limited clinical access
- **Clerk**: Appointments, billing, limited patient info

## Technical Considerations

### Performance
- Indexed foreign keys
- Materialized views for complex queries
- Pagination for large lists
- Lazy loading for related data

### Offline Support (Future)
- Local SQLite cache
- Sync queue for mutations
- Conflict resolution strategy

### Internationalization (Future)
- Multi-language support
- Date/time localization
- Measurement units (metric/imperial)

## Success Metrics
- ✅ All core modules functional
- ✅ RLS policies enforced
- ✅ Audit logs tracking all changes
- ✅ New modules can be added without schema changes
- ✅ Clean, modern UI with excellent UX
- ✅ Mobile-responsive design
