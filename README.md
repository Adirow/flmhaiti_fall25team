# FLM Haiti Clinic Management App

Welcome to the FLM Haiti digital clinic management application. This guide is written for FLM Haiti team members who may not work with code every day. It explains what the app does, the technology behind it, and why it benefits the organization.

## What the App Does

The application helps FLM Haiti teams coordinate patient care before, during, and after community clinics. Key capabilities include:

- **Appointment Scheduling** – register patients, book visits, and confirm attendance so clinic days stay organized.
- **Patient Records** – keep contact details, medical history, and visit notes together to support informed care.
- **Clinical Documentation** – capture encounter forms, questionnaires, and odontogram data for dental services.
- **Team Tools** – manage departments, assign tools and templates, and keep everyone aligned on the latest workflows.
- **Reporting Foundations** – data is stored in a structured way so insights can be generated about clinic performance and patient needs.

## How the Technology Works (Plain Language)

- The **mobile and web app** is built with Flutter, which means the same experience works on Android devices, iOS devices, and browsers.
- The **database and authentication** use Supabase (a secure cloud service based on PostgreSQL) to store appointments, patients, and staff information.
- The app talks to Supabase through clearly defined services so data stays synchronized and protected.
- The project includes automated scripts and configuration that keep the code consistent and ready for deployment.

## Why This Matters for FLM Haiti

- **One Source of Truth:** Everyone can see the same up-to-date schedule and patient records, reducing confusion and duplicate work.
- **Faster Clinics:** Pre-filled forms and reusable templates save time during intake and clinical encounters.
- **Better Follow-Up:** Notes and histories stay connected to each patient, making it easier to plan future visits.
- **Scalable Operations:** Cloud storage and cross-platform support allow the system to grow with FLM Haiti’s programs.
- **Secure and Compliant:** Supabase provides managed security features such as row-level access and encrypted connections.

## Getting Started (For Operators)

If you only need to use the app:

1. Ask your technical lead for the latest build (Android, iOS, or Web link).
2. Sign in with the credentials provided by the administrator.
3. Explore the appointment list, patient records, and forms to manage clinic tasks.

If you are responsible for running the app locally or updating it, follow the steps below.

### 1. Install Flutter

Download and install Flutter by following the official guide for your operating system: <https://docs.flutter.dev/get-started/install>

Verify your installation:

```bash
flutter --version
flutter doctor
```

### 2. Install Project Dependencies

Open a terminal in the project folder and run:

```bash
flutter pub get
```

### 3. Run the App

Choose the platform that suits your needs:

```bash
# Web
flutter run -d chrome

# Android APK
flutter build apk

# Web (production build)
flutter build web

# iOS (Mac only)
flutter build ios
```

## Additional Resources

- [Flutter Quick Start](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

For questions about deployment or credentials, contact the FLM Haiti technical coordinator.
