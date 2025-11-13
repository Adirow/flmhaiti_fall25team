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

  @override
  String questionnairesTitle(Object patientName) {
    return 'Questionnaires - $patientName';
  }

  @override
  String get questionnairesLoadErrorTitle => 'Failed to load questionnaires';

  @override
  String get questionnairesStartCardTitle => 'Start New Questionnaire';

  @override
  String get questionnairesNoTemplates =>
      'No questionnaire templates available';

  @override
  String get questionnairesSelectDepartment => 'Select Department';

  @override
  String questionnairesNoTemplatesForDepartment(String department) {
    return 'No templates available for $department';
  }

  @override
  String get questionnairesSelectTemplate => 'Select Questionnaire';

  @override
  String get questionnairesStartButton => 'Start Questionnaire';

  @override
  String get questionnairesPreviousTitle => 'Previous Questionnaires';

  @override
  String get questionnairesNoHistory => 'No previous questionnaires';

  @override
  String questionnairesStartError(String error) {
    return 'Failed to start questionnaire: $error';
  }

  @override
  String get questionnaireSavingLabel => 'Saving...';

  @override
  String get questionnaireStatusSubmitted => 'SUBMITTED';

  @override
  String get questionnaireStatusDraft => 'DRAFT';

  @override
  String questionnaireAutoSaveFailed(String error) {
    return 'Auto-save failed: $error';
  }

  @override
  String get questionnaireSubmitSuccess =>
      'Questionnaire submitted successfully!';

  @override
  String questionnaireSubmitError(String error) {
    return 'Failed to submit questionnaire: $error';
  }

  @override
  String get questionnaireLoadErrorTitle => 'Failed to load questionnaire';

  @override
  String get questionnaireEmptyTitle => 'No questions found';

  @override
  String get questionnaireEmptySubtitle =>
      'This questionnaire appears to be empty';

  @override
  String get questionnaireSubmitButton => 'Submit Questionnaire';

  @override
  String get questionnaireSubmittedReadOnlyMessage =>
      'This questionnaire has been submitted and is now read-only.';

  @override
  String questionnaireVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get questionnaireSelectDate => 'Select date...';

  @override
  String get questionnaireTextHint => 'Enter your answer...';

  @override
  String get questionnaireNumberHint => 'Enter a number...';

  @override
  String get questionnaireChoiceHint => 'Select an option...';

  @override
  String get questionnaireBooleanYes => 'Yes';

  @override
  String get encountersTitle => 'Encounters';

  @override
  String get encountersCreateNew => 'New Encounter';

  @override
  String get encountersContinue => 'Continue';

  @override
  String get encountersStatusInProgress => 'In Progress';

  @override
  String get encountersStatusCompleted => 'Completed';

  @override
  String get encountersStatusDraft => 'Draft';

  @override
  String encountersLastUpdated(Object time) {
    return 'Last updated $time';
  }

  @override
  String get encountersNoEncounters => 'No encounters yet';

  @override
  String get encountersNoEncountersSubtitle =>
      'Start by creating a new encounter';

  @override
  String get encountersLoadError => 'Failed to load encounters';

  @override
  String encountersStartError(Object error) {
    return 'Failed to start encounter: $error';
  }

  @override
  String get encountersDeleteConfirm => 'Delete encounter?';

  @override
  String get encountersDeleteMessage =>
      'Are you sure you want to delete this encounter?';

  @override
  String get encountersDeleteSuccess => 'Encounter deleted';

  @override
  String get encountersDeleteError => 'Failed to delete encounter';

  @override
  String get encountersToolsTitle => 'Encounter Tools';

  @override
  String get encountersToolVitals => 'Vitals';

  @override
  String get encountersToolNotes => 'Notes';

  @override
  String get encountersToolMedications => 'Medications';

  @override
  String get encountersToolProcedures => 'Procedures';

  @override
  String get encountersSave => 'Save';

  @override
  String get encountersSubmit => 'Submit';

  @override
  String get encountersCancel => 'Cancel';

  @override
  String get formsTitle => 'Form Templates';

  @override
  String get formsCreateNew => 'Create Template';

  @override
  String get formsEdit => 'Edit';

  @override
  String get formsDelete => 'Delete';

  @override
  String get formsDuplicate => 'Duplicate';

  @override
  String get formsPublish => 'Publish';

  @override
  String get formsUnpublish => 'Unpublish';

  @override
  String get formsActiveBadge => 'Active';

  @override
  String get formsDraftBadge => 'Draft';

  @override
  String get formsNoTemplates => 'No form templates';

  @override
  String get formsNoTemplatesSubtitle =>
      'Create your first template to get started';

  @override
  String get formsSearchHint => 'Search templates...';

  @override
  String formsLastUpdated(Object time) {
    return 'Last updated $time';
  }

  @override
  String get formsLoadError => 'Failed to load templates';

  @override
  String get formsCreateSuccess => 'Template created successfully';

  @override
  String get formsCreateError => 'Failed to create template';

  @override
  String get formsUpdateSuccess => 'Template updated successfully';

  @override
  String get formsUpdateError => 'Failed to update template';

  @override
  String get formsDeleteConfirm => 'Delete template?';

  @override
  String get formsDeleteMessage =>
      'Are you sure you want to delete this template?';

  @override
  String get formsDeleteSuccess => 'Template deleted';

  @override
  String get formsDeleteError => 'Failed to delete template';

  @override
  String get encountersLoadingTitle => 'Loading...';

  @override
  String get encountersEditTitle => 'Edit Encounter';

  @override
  String get encountersNewTitle => 'New Encounter';

  @override
  String get encountersInitErrorTitle => 'Failed to initialize encounter';

  @override
  String encountersInitError(String error) {
    return 'Failed to initialize encounter: $error';
  }

  @override
  String get encountersInfoSectionTitle => 'Encounter Information';

  @override
  String get encountersExamTypeLabel => 'Exam Type';

  @override
  String get encountersChiefComplaintLabel => 'Chief Complaint';

  @override
  String get encountersChiefComplaintHint => 'Main reason for visit';

  @override
  String get encountersChiefComplaintRequired => 'Please enter chief complaint';

  @override
  String get encountersNotesLabel => 'Clinical Notes';

  @override
  String get encountersNotesHint => 'Additional observations and notes';

  @override
  String get encountersSavedSuccess => 'Encounter saved successfully';

  @override
  String get encountersErrorMissingPatient =>
      'Patient information is missing. Please select a patient first.';

  @override
  String get encountersErrorNotLoggedIn =>
      'Please log in to create an encounter.';

  @override
  String get encountersErrorMissingClinic =>
      'Clinic information is missing. Please contact support.';

  @override
  String get encountersErrorDatabase =>
      'Database error. Please check your connection and try again.';

  @override
  String encountersErrorSave(String error) {
    return 'Failed to save encounter: $error';
  }

  @override
  String get encountersCloseTool => 'Close Tool';

  @override
  String get encountersNoTools => 'No tools available';

  @override
  String get encountersNoToolsSubtitle =>
      'Tools will appear here when configured for this department';

  @override
  String encountersToolLoadError(String toolId) {
    return 'Failed to load tool: $toolId';
  }

  @override
  String get encountersDepartmentsLoading => 'Loading departments...';

  @override
  String get encountersDepartmentsLoadError => 'Failed to load departments';

  @override
  String get encountersDepartmentsEmpty => 'No departments available';

  @override
  String get encountersDepartmentLabel => 'Department';

  @override
  String get formsStatusLabel => 'Status';

  @override
  String get formsStatusAll => 'All';

  @override
  String get formsStatusActive => 'Active';

  @override
  String get formsStatusArchived => 'Archived';

  @override
  String get formsNoTemplatesFound => 'No templates found';

  @override
  String get formsNoTemplatesSearch => 'No templates match your search';

  @override
  String get formsNoTemplatesSearchSubtitle =>
      'Try adjusting your search terms';

  @override
  String formsDuplicateSuccess(String name) {
    return 'Template \"$name\" duplicated successfully';
  }

  @override
  String formsDuplicateError(String error) {
    return 'Failed to duplicate template: $error';
  }

  @override
  String get formsArchiveConfirmTitle => 'Archive Template';

  @override
  String formsArchiveConfirmMessage(String name) {
    return 'Are you sure you want to archive \"$name\"? It will no longer be available for new forms.';
  }

  @override
  String get formsArchiveAction => 'Archive';

  @override
  String formsArchiveSuccess(String name) {
    return 'Template \"$name\" archived';
  }

  @override
  String formsArchiveError(String error) {
    return 'Failed to archive template: $error';
  }

  @override
  String get formsDetailsArchivedBadge => 'ARCHIVED';

  @override
  String get formsNoDescription => 'No description';

  @override
  String get formsPopupEdit => 'Edit';

  @override
  String get formsPopupDuplicate => 'Duplicate';

  @override
  String get formsPopupArchive => 'Archive';

  @override
  String get formsSectionsTitle => 'Sections';

  @override
  String get formsSectionsAddTooltip => 'Add Section';

  @override
  String get formsSectionsEmptyTitle => 'No sections yet';

  @override
  String get formsSectionsEmptySubtitle => 'Add a section to get started';

  @override
  String get formsQuestionsPlaceholder => 'Select a section to edit questions';

  @override
  String get formsPreviewModeNotice => 'Preview mode – inputs are disabled';

  @override
  String formsSectionIndexLabel(int index) {
    return 'Section $index';
  }

  @override
  String get formsSectionRename => 'Rename';

  @override
  String get formsSectionDelete => 'Delete';

  @override
  String get formsSectionDeleteTitle => 'Delete Section';

  @override
  String formsSectionDeleteMessage(String name) {
    return 'Are you sure you want to delete \"$name\"? This will also delete all questions in this section.';
  }

  @override
  String get formsUnsavedBadge => 'UNSAVED';

  @override
  String get formsTemplateInfoTitle => 'Template Information';

  @override
  String get formsTemplateNameLabel => 'Template Name';

  @override
  String get formsTemplateNameRequired => 'Please enter a template name';

  @override
  String get formsTemplateNameHint => 'Enter template name';

  @override
  String get formsTemplateDescriptionLabel => 'Description';

  @override
  String get formsTemplateDescriptionHint => 'Enter template description';

  @override
  String get formsSaveSuccess => 'Template saved successfully';

  @override
  String formsSaveError(String error) {
    return 'Failed to save template: $error';
  }

  @override
  String get formsDiscardChangesTitle => 'Unsaved Changes';

  @override
  String get formsDiscardChangesMessage =>
      'You have unsaved changes. Do you want to discard them?';

  @override
  String get formsDiscardButton => 'Discard';

  @override
  String get formsTabTemplate => 'Template';

  @override
  String get formsTabSections => 'Sections';

  @override
  String get formsTabPreview => 'Preview';
}
