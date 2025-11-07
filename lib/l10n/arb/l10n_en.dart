// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Dental EMR';

  @override
  String get loginTitle => 'House of David';

  @override
  String get loginSubtitle => 'FLM Haiti EMR';

  @override
  String get loginTagline => 'Developed by CMU Heinz College Capstone Team';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailRequiredError => 'Please enter email';

  @override
  String get emailInvalidError => 'Please enter valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordRequiredError => 'Please enter password';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get signUpPrompt => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardWelcome => 'House of David - Welcome Back!';

  @override
  String get dashboardSubheading =>
      'Developed by CMU Heinz College Capstone Team';

  @override
  String get patientsCardTitle => 'Patients';

  @override
  String get patientsCardSubtitle => 'Manage patient records';

  @override
  String get appointmentsCardTitle => 'Appointments';

  @override
  String get appointmentsCardSubtitle => 'Schedule & manage';

  @override
  String get encountersCardTitle => 'Encounters';

  @override
  String get encountersCardSubtitle => 'Clinical exams';

  @override
  String get formsCardTitle => 'Form Templates';

  @override
  String get formsCardSubtitle => 'Manage questionnaires';

  @override
  String get reportsCardTitle => 'Reports (In progress)';

  @override
  String get reportsCardSubtitle => 'Analytics & insights';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get todaysAppointments => 'Today\'s Appointments';

  @override
  String get pendingReviews => 'Pending Reviews';

  @override
  String get newPatientsThisWeek => 'New Patients This Week';

  @override
  String get languageSelectorLabel => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';

  @override
  String get languageHaitianCreole => 'Haitian Creole';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get patientsAddTitle => 'Add New Patient';

  @override
  String get patientsNameLabel => 'Full Name';

  @override
  String get patientsNameRequired => 'Please enter name';

  @override
  String get patientsGenderLabel => 'Gender';

  @override
  String get patientsGenderRequired => 'Please select gender';

  @override
  String get patientsDobLabel => 'Date of Birth';

  @override
  String get patientsDobPlaceholder => 'Select date';

  @override
  String get patientsDobSelectPlaceholder => 'Select Date of Birth';

  @override
  String get patientsPhoneLabel => 'Phone Number';

  @override
  String get patientsPhoneRequired => 'Please enter phone';

  @override
  String get patientsAddressLabel => 'Address';

  @override
  String get patientsAddressRequired => 'Please enter address';

  @override
  String get patientsBloodPressureLabel => 'Blood Pressure';

  @override
  String get patientsBloodPressureHint => 'e.g., 120/80';

  @override
  String get patientsBloodPressureOptionalLabel => 'Blood Pressure (optional)';

  @override
  String get patientsSaveButton => 'Save Patient';

  @override
  String get commonRequiredFieldsError => 'Please fill all required fields';

  @override
  String get commonUserNotAuthenticated => 'User not authenticated';

  @override
  String get patientsAddSuccess => 'Patient added successfully';

  @override
  String get patientsAddError => 'Failed to add patient';

  @override
  String get patientsDuplicateNameTitle => 'Duplicate Name Found';

  @override
  String patientsDuplicateNameMessage(Object count, Object name) {
    return 'The name \"$name\" is already used by $count patient(s). Continue saving?';
  }

  @override
  String get patientsDuplicateExisting => 'Existing patients:';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get patientsDuplicateContinueButton => 'Yes, Save Anyway';

  @override
  String get patientsDetailTitle => 'Patient Details';

  @override
  String get patientsIdLabel => 'Patient ID';

  @override
  String get patientsAgeLabel => 'Age';

  @override
  String get patientsAgeYearsSuffix => 'years';

  @override
  String get patientsBornLabel => 'Born';

  @override
  String get patientsQuickActions => 'Quick Actions';

  @override
  String get patientsMedicalHistoryAction => 'Medical History';

  @override
  String get patientsNewEncounterAction => 'New Encounter';

  @override
  String get patientsQuestionnairesAction => 'Questionnaires';

  @override
  String get patientsAppointmentsAction => 'Appointments';

  @override
  String get patientsDocumentsAction => 'Documents';

  @override
  String get patientsReportsAction => 'Reports';

  @override
  String get patientsRecentEncounters => 'Recent Encounters';

  @override
  String get patientsEncounterTypeRoutineCheckup => 'Routine Checkup';

  @override
  String get patientsEncounterTypeDentalCleaning => 'Dental Cleaning';

  @override
  String get patientsEncounterTypeToothExtraction => 'Tooth Extraction';

  @override
  String get patientsNewButtonLabel => 'New Patient';

  @override
  String get patientsSearchHint => 'Search patients...';

  @override
  String get patientsLoadErrorTitle => 'Failed to load patients';

  @override
  String get commonRetry => 'Retry';

  @override
  String get patientsEmptyTitle => 'No patients found';

  @override
  String get patientsEmptySubtitle => 'Add your first patient to get started';

  @override
  String get patientsSearchNoResultsTitle => 'No patients match your search';

  @override
  String get patientsSearchNoResultsSubtitle =>
      'Try adjusting your search terms';

  @override
  String get patientsEditingTitle => 'Editing Patient';

  @override
  String get patientsSaveChangesButton => 'Save Changes';

  @override
  String get patientsUpdateSuccess => 'Patient updated successfully';

  @override
  String get patientsUpdateError => 'Failed to update patient';

  @override
  String get patientsDeleteTitle => 'Delete Patient';

  @override
  String patientsDeleteConfirmationMessage(Object name) {
    return 'Are you sure you want to delete $name? This action cannot be undone.';
  }

  @override
  String get commonDelete => 'Delete';

  @override
  String get patientsDeleteSuccess => 'Patient deleted successfully';

  @override
  String get patientsDeleteError => 'Failed to delete patient';
}
