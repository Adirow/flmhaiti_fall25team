# Appointment Module Overview

## Purpose and Scope
The appointment module manages the full lifecycle of scheduling interactions between patients and providers. It exposes Flutter UI for creating and editing appointments, communicates with Supabase-backed services to persist data, and ensures the appointment state machine stays in sync with the database `appointment_status_enum`. The module currently supports status transitions across **scheduled → confirmed → in progress → completed/cancelled** and provides guardrails that prevent invalid dates, duplicate patients, or missing provider context.

## High-Level Architecture

| Layer | Responsibilities | Key Elements |
| --- | --- | --- |
| Presentation (Flutter UI) | Collects user input, validates forms, and triggers persistence. | `AppointmentFormScreen` (`lib/screens/appointments/appointment_form_screen.dart`)
| Domain Models | Typed representation of appointments with serialization helpers. | `Appointment` & `AppointmentStatus` (`lib/models/appointment.dart`)
| Data Services | Abstracts Supabase queries/mutations for appointments. | `AppointmentService` (`lib/services/appointment_service.dart`)
| Backend (Supabase) | Stores appointment records and enforces enum constraints. | `public.appointments` table & `appointment_status_enum`

This layered design keeps Supabase-specific logic in the service layer while exposing a lightweight API to the UI. Models mediate between JSON payloads and strongly typed Dart structures.

## Core Features

1. **Create Appointments**
   - Users choose a patient, specify reason, date, and time slots.
   - On save, the UI constructs an `Appointment` instance and delegates persistence to `AppointmentService.createAppointment`, which posts to Supabase and refreshes the caller via the `onSaved` callback.

2. **Edit Existing Appointments**
   - When loading an appointment, the form pre-populates field controllers and rehydrates the status dropdown using `AppointmentStatusX.fromDbValue`.
   - Patient selection gracefully handles stale data by re-querying Supabase if the cached list is missing the appointment’s patient and merging it into `_patients`.

3. **Status Management**
   - Enum values map cleanly between Dart and SQL via `AppointmentStatusX._dbValues`. The extension guarantees that serialized payloads always align with the database enum values (`scheduled`, `confirmed`, `in_progress`, `completed`, `cancelled`).

4. **Provider Context Handling**
   - While creating new appointments, the form attempts to associate the current Supabase user as the provider. If no profile exists, it attempts to create a minimal profile record before falling back to a null provider.

5. **Form Validation**
   - The UI enforces that end times occur after start times and that a patient is selected before allowing submission. Errors surface through `SnackBar` alerts.

## Data Flow Walkthrough

1. **Initialization**
   - `AppointmentFormScreen` triggers `_loadPatients()` and `_initializeForm()` inside `initState`.
   - `_loadPatients()` fetches all patients via `PatientService.getAllPatients()`, clones the result into a mutable list, and ensures the selected patient is present even if the list is stale.

2. **Editing Path**
   - When editing, `_loadSelectedPatient()` fetches the specific patient ID in case the global patient list omitted it, inserting the record into `_patients` if necessary.
   - Status and time widgets reflect the persisted appointment using the domain model’s `AppointmentStatus` enumeration.

3. **Saving Path**
   - The form consolidates the selected date and `TimeOfDay` values into `DateTime` objects before invoking `AppointmentService`.
   - On creation, the service serializes the appointment to JSON via `toJson()` and posts to Supabase.
   - On update, the form constructs a copy with `copyWith` and the service executes an update call targeting the appointment ID.

## Recent Bug Fixes

### 1. Enum Synchronization Failure
- **Issue**: Editing the appointment status failed because Supabase rejected values such as `confirmed` and `in_progress`. The database enum only contained `scheduled` while the Flutter UI allowed all five states.
- **Resolution**:
  1. Expanded the Dart `AppointmentStatus` enum and ensured `AppointmentStatusX.fromDbValue` gracefully handles every status string.
  2. Updated `AppointmentService` to rely on the unified mapping when persisting appointments.
  3. **Database Action**: Run the following SQL once in Supabase to align the enum values:
     ```sql
     ALTER TYPE appointment_status_enum ADD VALUE IF NOT EXISTS 'confirmed';
     ALTER TYPE appointment_status_enum ADD VALUE IF NOT EXISTS 'in_progress';
     ALTER TYPE appointment_status_enum ADD VALUE IF NOT EXISTS 'completed';
     ALTER TYPE appointment_status_enum ADD VALUE IF NOT EXISTS 'cancelled';
     ```
- **Outcome**: The edit screen can now both read and write all supported status values without constraint violations.

### 2. Patient Selector Inconsistency During Edits
- **Issue**: Editing an appointment sometimes showed an empty patient dropdown because the previously selected patient was not part of the fetched list.
- **Resolution**: `_loadPatients()` now clones the fetched list into a mutable instance, checks whether the selected patient is present, and inserts or replaces entries as needed. `_loadSelectedPatient()` ensures that the edited appointment’s patient is always injected into `_patients`.

## Testing & Validation Tips

- **Manual**: Use the appointment edit screen to change status across all permutations. Confirm Supabase accepts each transition after the enum migration.
- **Edge Cases**: Attempt to schedule with end times before start times to ensure validation prevents submission.
- **Data Integrity**: Inspect Supabase `appointments` records and verify `status` strings match the Dart enum values.

## Future Enhancements

- Integrate automated Supabase migrations so enum updates travel with the codebase.
- Expose audit history for status transitions to improve traceability.
- Add automated widget tests for the form validation and patient selection logic.

This document should provide enough context to onboard new contributors to the appointment module and explain the recent fixes that restored the edit workflow.
