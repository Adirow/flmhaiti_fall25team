import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_fr.dart';
import 'l10n_ht.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ht')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Dental EMR'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'House of David'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FLM Haiti EMR'**
  String get loginSubtitle;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Developed by CMU Heinz College Capstone Team'**
  String get loginTagline;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get emailRequiredError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get emailInvalidError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please enter password'**
  String get passwordRequiredError;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signUpPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get signUpPrompt;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardWelcome.
  ///
  /// In en, this message translates to:
  /// **'House of David - Welcome Back!'**
  String get dashboardWelcome;

  /// No description provided for @dashboardSubheading.
  ///
  /// In en, this message translates to:
  /// **'Developed by CMU Heinz College Capstone Team'**
  String get dashboardSubheading;

  /// No description provided for @dashboardProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get dashboardProfileTitle;

  /// No description provided for @dashboardProfileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get dashboardProfileNameLabel;

  /// No description provided for @dashboardProfileRoleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get dashboardProfileRoleLabel;

  /// No description provided for @dashboardProfileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email / Username'**
  String get dashboardProfileEmailLabel;

  /// No description provided for @dashboardProfileLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashboardProfileLogout;

  /// No description provided for @dashboardProfileLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading profile...'**
  String get dashboardProfileLoading;

  /// No description provided for @dashboardProfileError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get dashboardProfileError;

  /// No description provided for @patientsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsCardTitle;

  /// No description provided for @patientsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage patient records'**
  String get patientsCardSubtitle;

  /// No description provided for @appointmentsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsCardTitle;

  /// No description provided for @appointmentsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule & manage'**
  String get appointmentsCardSubtitle;

  /// No description provided for @appointmentsStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get appointmentsStatusScheduled;

  /// No description provided for @appointmentsStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get appointmentsStatusConfirmed;

  /// No description provided for @appointmentsStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get appointmentsStatusInProgress;

  /// No description provided for @appointmentsStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get appointmentsStatusCompleted;

  /// No description provided for @appointmentsStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get appointmentsStatusCancelled;

  /// No description provided for @appointmentsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All Appointments'**
  String get appointmentsFilterAll;

  /// No description provided for @appointmentsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No appointments found'**
  String get appointmentsEmptyTitle;

  /// No description provided for @appointmentsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to schedule a new appointment'**
  String get appointmentsEmptySubtitle;

  /// No description provided for @appointmentsUnknownPatient.
  ///
  /// In en, this message translates to:
  /// **'Unknown Patient'**
  String get appointmentsUnknownPatient;

  /// No description provided for @appointmentsActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get appointmentsActionConfirm;

  /// No description provided for @appointmentsActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get appointmentsActionEdit;

  /// No description provided for @appointmentsActionReschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get appointmentsActionReschedule;

  /// No description provided for @appointmentsActionStart.
  ///
  /// In en, this message translates to:
  /// **'Start Appointment'**
  String get appointmentsActionStart;

  /// No description provided for @appointmentsActionComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get appointmentsActionComplete;

  /// No description provided for @appointmentsNewButton.
  ///
  /// In en, this message translates to:
  /// **'New Appointment'**
  String get appointmentsNewButton;

  /// No description provided for @appointmentsSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Appointments'**
  String get appointmentsSearchTitle;

  /// No description provided for @appointmentsSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search by patient name or reason'**
  String get appointmentsSearchLabel;

  /// No description provided for @appointmentsSearchButton.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get appointmentsSearchButton;

  /// No description provided for @appointmentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load appointments: {error}'**
  String appointmentsLoadError(Object error);

  /// No description provided for @appointmentsSearchError.
  ///
  /// In en, this message translates to:
  /// **'Failed to search appointments: {error}'**
  String appointmentsSearchError(Object error);

  /// No description provided for @appointmentsConfirmSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment confirmed'**
  String get appointmentsConfirmSuccess;

  /// No description provided for @appointmentsCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled'**
  String get appointmentsCancelSuccess;

  /// No description provided for @appointmentsActionError.
  ///
  /// In en, this message translates to:
  /// **'Failed to {action} appointment: {error}'**
  String appointmentsActionError(Object action, Object error);

  /// No description provided for @appointmentsRescheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Appointment'**
  String get appointmentsRescheduleTitle;

  /// No description provided for @appointmentsRescheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String appointmentsRescheduleDate(Object date);

  /// No description provided for @appointmentsRescheduleTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String appointmentsRescheduleTime(Object time);

  /// No description provided for @appointmentsRescheduleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment rescheduled'**
  String get appointmentsRescheduleSuccess;

  /// No description provided for @appointmentsRescheduleError.
  ///
  /// In en, this message translates to:
  /// **'Failed to reschedule: {error}'**
  String appointmentsRescheduleError(Object error);

  /// No description provided for @appointmentsRescheduleButton.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get appointmentsRescheduleButton;

  /// No description provided for @appointmentsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment'**
  String get appointmentsDeleteTitle;

  /// No description provided for @appointmentsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment? This action cannot be undone.'**
  String get appointmentsDeleteMessage;

  /// No description provided for @appointmentsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment deleted'**
  String get appointmentsDeleteSuccess;

  /// No description provided for @appointmentsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete appointment: {error}'**
  String appointmentsDeleteError(Object error);

  /// No description provided for @appointmentsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentsDetailTitle;

  /// No description provided for @appointmentsStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appointment status updated to {status}'**
  String appointmentsStatusUpdated(Object status);

  /// No description provided for @appointmentsStatusUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status: {error}'**
  String appointmentsStatusUpdateError(Object error);

  /// No description provided for @appointmentsIdLabel.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}...'**
  String appointmentsIdLabel(Object id);

  /// No description provided for @appointmentsPatientInformation.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get appointmentsPatientInformation;

  /// No description provided for @appointmentsFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get appointmentsFieldName;

  /// No description provided for @appointmentsFieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get appointmentsFieldPhone;

  /// No description provided for @appointmentsFieldAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get appointmentsFieldAge;

  /// No description provided for @appointmentsAgeValue.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String appointmentsAgeValue(Object age);

  /// No description provided for @appointmentsInformation.
  ///
  /// In en, this message translates to:
  /// **'Appointment Information'**
  String get appointmentsInformation;

  /// No description provided for @appointmentsFieldReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get appointmentsFieldReason;

  /// No description provided for @appointmentsFieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get appointmentsFieldDate;

  /// No description provided for @appointmentsFieldTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get appointmentsFieldTime;

  /// No description provided for @appointmentsFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get appointmentsFieldDuration;

  /// No description provided for @appointmentsDurationValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} minutes'**
  String appointmentsDurationValue(Object minutes);

  /// No description provided for @appointmentsTimestamps.
  ///
  /// In en, this message translates to:
  /// **'Timestamps'**
  String get appointmentsTimestamps;

  /// No description provided for @appointmentsFieldCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get appointmentsFieldCreated;

  /// No description provided for @appointmentsFieldUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get appointmentsFieldUpdated;

  /// No description provided for @appointmentsFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Appointment'**
  String get appointmentsFormNewTitle;

  /// No description provided for @appointmentsFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Appointment'**
  String get appointmentsFormEditTitle;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @appointmentsSelectPatientLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Patient'**
  String get appointmentsSelectPatientLabel;

  /// No description provided for @appointmentsSelectPatientError.
  ///
  /// In en, this message translates to:
  /// **'Please select a patient'**
  String get appointmentsSelectPatientError;

  /// No description provided for @appointmentsReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for Visit'**
  String get appointmentsReasonLabel;

  /// No description provided for @appointmentsReasonError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason for the visit'**
  String get appointmentsReasonError;

  /// No description provided for @appointmentsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get appointmentsStatusLabel;

  /// No description provided for @appointmentsStartTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get appointmentsStartTimeLabel;

  /// No description provided for @appointmentsEndTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get appointmentsEndTimeLabel;

  /// No description provided for @appointmentsCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create Appointment'**
  String get appointmentsCreateButton;

  /// No description provided for @appointmentsUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Update Appointment'**
  String get appointmentsUpdateButton;

  /// No description provided for @appointmentsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment created successfully'**
  String get appointmentsCreateSuccess;

  /// No description provided for @appointmentsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get appointmentsUpdateSuccess;

  /// No description provided for @appointmentsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save appointment: {error}'**
  String appointmentsSaveError(Object error);

  /// No description provided for @appointmentsEndTimeError.
  ///
  /// In en, this message translates to:
  /// **'End time must be after start time'**
  String get appointmentsEndTimeError;

  /// No description provided for @appointmentsLoadPatientsError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patients: {error}'**
  String appointmentsLoadPatientsError(Object error);

  /// No description provided for @appointmentsLoadPatientError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patient: {error}'**
  String appointmentsLoadPatientError(Object error);

  /// No description provided for @encountersCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Encounters'**
  String get encountersCardTitle;

  /// No description provided for @encountersCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clinical exams'**
  String get encountersCardSubtitle;

  /// No description provided for @formsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Form Templates'**
  String get formsCardTitle;

  /// No description provided for @formsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage questionnaires'**
  String get formsCardSubtitle;

  /// No description provided for @reportsCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports (In progress)'**
  String get reportsCardTitle;

  /// No description provided for @reportsCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics & insights'**
  String get reportsCardSubtitle;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @todaysAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get todaysAppointments;

  /// No description provided for @pendingReviews.
  ///
  /// In en, this message translates to:
  /// **'Pending Reviews'**
  String get pendingReviews;

  /// No description provided for @newPatientsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New Patients This Week'**
  String get newPatientsThisWeek;

  /// No description provided for @languageSelectorLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelectorLabel;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @languageHaitianCreole.
  ///
  /// In en, this message translates to:
  /// **'Haitian Creole'**
  String get languageHaitianCreole;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @patientsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get patientsAddTitle;

  /// No description provided for @patientsNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get patientsNameLabel;

  /// No description provided for @patientsNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get patientsNameRequired;

  /// No description provided for @patientsGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get patientsGenderLabel;

  /// No description provided for @patientsGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get patientsGenderRequired;

  /// No description provided for @patientsDobLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get patientsDobLabel;

  /// No description provided for @patientsDobPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get patientsDobPlaceholder;

  /// No description provided for @patientsDobSelectPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select Date of Birth'**
  String get patientsDobSelectPlaceholder;

  /// No description provided for @patientsPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get patientsPhoneLabel;

  /// No description provided for @patientsPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone'**
  String get patientsPhoneRequired;

  /// No description provided for @patientsAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get patientsAddressLabel;

  /// No description provided for @patientsAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter address'**
  String get patientsAddressRequired;

  /// No description provided for @patientsBloodPressureLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get patientsBloodPressureLabel;

  /// No description provided for @patientsBloodPressureHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 120/80'**
  String get patientsBloodPressureHint;

  /// No description provided for @patientsBloodPressureOptionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure (optional)'**
  String get patientsBloodPressureOptionalLabel;

  /// No description provided for @patientsSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save Patient'**
  String get patientsSaveButton;

  /// No description provided for @commonRequiredFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get commonRequiredFieldsError;

  /// No description provided for @commonUserNotAuthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated'**
  String get commonUserNotAuthenticated;

  /// No description provided for @patientsAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Patient added successfully'**
  String get patientsAddSuccess;

  /// No description provided for @patientsAddError.
  ///
  /// In en, this message translates to:
  /// **'Failed to add patient'**
  String get patientsAddError;

  /// No description provided for @patientsDuplicateNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Name Found'**
  String get patientsDuplicateNameTitle;

  /// No description provided for @patientsDuplicateNameMessage.
  ///
  /// In en, this message translates to:
  /// **'The name \"{name}\" is already used by {count} patient(s). Continue saving?'**
  String patientsDuplicateNameMessage(Object count, Object name);

  /// No description provided for @patientsDuplicateExisting.
  ///
  /// In en, this message translates to:
  /// **'Existing patients:'**
  String get patientsDuplicateExisting;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @patientsDuplicateContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, Save Anyway'**
  String get patientsDuplicateContinueButton;

  /// No description provided for @patientsDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientsDetailTitle;

  /// No description provided for @patientsIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient ID'**
  String get patientsIdLabel;

  /// No description provided for @patientsAgeLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get patientsAgeLabel;

  /// No description provided for @patientsAgeYearsSuffix.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get patientsAgeYearsSuffix;

  /// No description provided for @patientsBornLabel.
  ///
  /// In en, this message translates to:
  /// **'Born'**
  String get patientsBornLabel;

  /// No description provided for @patientsQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get patientsQuickActions;

  /// No description provided for @patientsMedicalHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get patientsMedicalHistoryAction;

  /// No description provided for @patientsNewEncounterAction.
  ///
  /// In en, this message translates to:
  /// **'New Encounter'**
  String get patientsNewEncounterAction;

  /// No description provided for @patientsQuestionnairesAction.
  ///
  /// In en, this message translates to:
  /// **'Questionnaires'**
  String get patientsQuestionnairesAction;

  /// No description provided for @patientsAppointmentsAction.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get patientsAppointmentsAction;

  /// No description provided for @patientsDocumentsAction.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get patientsDocumentsAction;

  /// No description provided for @patientsReportsAction.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get patientsReportsAction;

  /// No description provided for @patientsRecentEncounters.
  ///
  /// In en, this message translates to:
  /// **'Recent Encounters'**
  String get patientsRecentEncounters;

  /// No description provided for @patientsEncounterTypeRoutineCheckup.
  ///
  /// In en, this message translates to:
  /// **'Routine Checkup'**
  String get patientsEncounterTypeRoutineCheckup;

  /// No description provided for @patientsEncounterTypeDentalCleaning.
  ///
  /// In en, this message translates to:
  /// **'Dental Cleaning'**
  String get patientsEncounterTypeDentalCleaning;

  /// No description provided for @patientsEncounterTypeToothExtraction.
  ///
  /// In en, this message translates to:
  /// **'Tooth Extraction'**
  String get patientsEncounterTypeToothExtraction;

  /// No description provided for @patientsNewButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'New Patient'**
  String get patientsNewButtonLabel;

  /// No description provided for @patientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search patients...'**
  String get patientsSearchHint;

  /// No description provided for @patientsLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load patients'**
  String get patientsLoadErrorTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @patientsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No patients found'**
  String get patientsEmptyTitle;

  /// No description provided for @patientsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first patient to get started'**
  String get patientsEmptySubtitle;

  /// No description provided for @patientsSearchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No patients match your search'**
  String get patientsSearchNoResultsTitle;

  /// No description provided for @patientsSearchNoResultsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get patientsSearchNoResultsSubtitle;

  /// No description provided for @patientsEditingTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing Patient'**
  String get patientsEditingTitle;

  /// No description provided for @patientsSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get patientsSaveChangesButton;

  /// No description provided for @patientsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Patient updated successfully'**
  String get patientsUpdateSuccess;

  /// No description provided for @patientsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update patient'**
  String get patientsUpdateError;

  /// No description provided for @patientsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Patient'**
  String get patientsDeleteTitle;

  /// No description provided for @patientsDeleteConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}? This action cannot be undone.'**
  String patientsDeleteConfirmationMessage(Object name);

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @patientsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Patient deleted successfully'**
  String get patientsDeleteSuccess;

  /// No description provided for @patientsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete patient'**
  String get patientsDeleteError;

  /// Title for questionnaires page with patient name
  ///
  /// In en, this message translates to:
  /// **'Questionnaires - {patientName}'**
  String questionnairesTitle(Object patientName);

  /// No description provided for @questionnairesLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questionnaires'**
  String get questionnairesLoadErrorTitle;

  /// No description provided for @questionnairesStartCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Start New Questionnaire'**
  String get questionnairesStartCardTitle;

  /// No description provided for @questionnairesNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No questionnaire templates available'**
  String get questionnairesNoTemplates;

  /// No description provided for @questionnairesSelectDepartment.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get questionnairesSelectDepartment;

  /// Message when no templates for a department
  ///
  /// In en, this message translates to:
  /// **'No templates available for {department}'**
  String questionnairesNoTemplatesForDepartment(String department);

  /// No description provided for @questionnairesSelectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select Questionnaire'**
  String get questionnairesSelectTemplate;

  /// No description provided for @questionnairesStartButton.
  ///
  /// In en, this message translates to:
  /// **'Start Questionnaire'**
  String get questionnairesStartButton;

  /// No description provided for @questionnairesPreviousTitle.
  ///
  /// In en, this message translates to:
  /// **'Previous Questionnaires'**
  String get questionnairesPreviousTitle;

  /// No description provided for @questionnairesNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No previous questionnaires'**
  String get questionnairesNoHistory;

  /// No description provided for @questionnairesStartError.
  ///
  /// In en, this message translates to:
  /// **'Failed to start questionnaire: {error}'**
  String questionnairesStartError(String error);

  /// No description provided for @questionnaireSavingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get questionnaireSavingLabel;

  /// No description provided for @questionnaireStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'SUBMITTED'**
  String get questionnaireStatusSubmitted;

  /// No description provided for @questionnaireStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'DRAFT'**
  String get questionnaireStatusDraft;

  /// No description provided for @questionnaireAutoSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Auto-save failed: {error}'**
  String questionnaireAutoSaveFailed(String error);

  /// No description provided for @questionnaireSubmitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire submitted successfully!'**
  String get questionnaireSubmitSuccess;

  /// No description provided for @questionnaireSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit questionnaire: {error}'**
  String questionnaireSubmitError(String error);

  /// No description provided for @questionnaireLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to load questionnaire'**
  String get questionnaireLoadErrorTitle;

  /// No description provided for @questionnaireEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No questions found'**
  String get questionnaireEmptyTitle;

  /// No description provided for @questionnaireEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This questionnaire appears to be empty'**
  String get questionnaireEmptySubtitle;

  /// No description provided for @questionnaireSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Questionnaire'**
  String get questionnaireSubmitButton;

  /// No description provided for @questionnaireSubmittedReadOnlyMessage.
  ///
  /// In en, this message translates to:
  /// **'This questionnaire has been submitted and is now read-only.'**
  String get questionnaireSubmittedReadOnlyMessage;

  /// No description provided for @questionnaireVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String questionnaireVersionLabel(String version);

  /// No description provided for @questionnaireSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date...'**
  String get questionnaireSelectDate;

  /// No description provided for @questionnaireTextHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer...'**
  String get questionnaireTextHint;

  /// No description provided for @questionnaireNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a number...'**
  String get questionnaireNumberHint;

  /// No description provided for @questionnaireChoiceHint.
  ///
  /// In en, this message translates to:
  /// **'Select an option...'**
  String get questionnaireChoiceHint;

  /// No description provided for @questionnaireBooleanYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get questionnaireBooleanYes;

  /// No description provided for @encountersTitle.
  ///
  /// In en, this message translates to:
  /// **'Encounters'**
  String get encountersTitle;

  /// No description provided for @encountersCreateNew.
  ///
  /// In en, this message translates to:
  /// **'New Encounter'**
  String get encountersCreateNew;

  /// No description provided for @encountersContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get encountersContinue;

  /// No description provided for @encountersStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get encountersStatusInProgress;

  /// No description provided for @encountersStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get encountersStatusCompleted;

  /// No description provided for @encountersStatusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get encountersStatusDraft;

  /// No description provided for @encountersLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}'**
  String encountersLastUpdated(Object time);

  /// No description provided for @encountersNoEncounters.
  ///
  /// In en, this message translates to:
  /// **'No encounters yet'**
  String get encountersNoEncounters;

  /// No description provided for @encountersNoEncountersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by creating a new encounter'**
  String get encountersNoEncountersSubtitle;

  /// No description provided for @encountersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load encounters'**
  String get encountersLoadError;

  /// No description provided for @encountersStartError.
  ///
  /// In en, this message translates to:
  /// **'Failed to start encounter: {error}'**
  String encountersStartError(Object error);

  /// No description provided for @encountersDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete encounter?'**
  String get encountersDeleteConfirm;

  /// No description provided for @encountersDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this encounter?'**
  String get encountersDeleteMessage;

  /// No description provided for @encountersDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Encounter deleted'**
  String get encountersDeleteSuccess;

  /// No description provided for @encountersDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete encounter'**
  String get encountersDeleteError;

  /// No description provided for @encountersToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Encounter Tools'**
  String get encountersToolsTitle;

  /// No description provided for @encountersToolVitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get encountersToolVitals;

  /// No description provided for @encountersToolNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get encountersToolNotes;

  /// No description provided for @encountersToolMedications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get encountersToolMedications;

  /// No description provided for @encountersToolProcedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get encountersToolProcedures;

  /// No description provided for @encountersSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get encountersSave;

  /// No description provided for @encountersSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get encountersSubmit;

  /// No description provided for @encountersCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get encountersCancel;

  /// No description provided for @formsTitle.
  ///
  /// In en, this message translates to:
  /// **'Form Templates'**
  String get formsTitle;

  /// No description provided for @formsCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get formsCreateNew;

  /// No description provided for @formsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get formsEdit;

  /// No description provided for @formsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get formsDelete;

  /// No description provided for @formsDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get formsDuplicate;

  /// No description provided for @formsPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get formsPublish;

  /// No description provided for @formsUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Unpublish'**
  String get formsUnpublish;

  /// No description provided for @formsActiveBadge.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get formsActiveBadge;

  /// No description provided for @formsDraftBadge.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get formsDraftBadge;

  /// No description provided for @formsNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No form templates'**
  String get formsNoTemplates;

  /// No description provided for @formsNoTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first template to get started'**
  String get formsNoTemplatesSubtitle;

  /// No description provided for @formsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search templates...'**
  String get formsSearchHint;

  /// No description provided for @formsLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}'**
  String formsLastUpdated(Object time);

  /// No description provided for @formsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load templates'**
  String get formsLoadError;

  /// No description provided for @formsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template created successfully'**
  String get formsCreateSuccess;

  /// No description provided for @formsCreateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to create template'**
  String get formsCreateError;

  /// No description provided for @formsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template updated successfully'**
  String get formsUpdateSuccess;

  /// No description provided for @formsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update template'**
  String get formsUpdateError;

  /// No description provided for @formsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete template?'**
  String get formsDeleteConfirm;

  /// No description provided for @formsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this template?'**
  String get formsDeleteMessage;

  /// No description provided for @formsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get formsDeleteSuccess;

  /// No description provided for @formsDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete template'**
  String get formsDeleteError;

  /// No description provided for @encountersLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get encountersLoadingTitle;

  /// No description provided for @encountersEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Encounter'**
  String get encountersEditTitle;

  /// No description provided for @encountersNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New Encounter'**
  String get encountersNewTitle;

  /// No description provided for @encountersInitErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize encounter'**
  String get encountersInitErrorTitle;

  /// No description provided for @encountersInitError.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize encounter: {error}'**
  String encountersInitError(String error);

  /// No description provided for @encountersInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Encounter Information'**
  String get encountersInfoSectionTitle;

  /// No description provided for @encountersExamTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Exam Type'**
  String get encountersExamTypeLabel;

  /// No description provided for @encountersChiefComplaintLabel.
  ///
  /// In en, this message translates to:
  /// **'Chief Complaint'**
  String get encountersChiefComplaintLabel;

  /// No description provided for @encountersChiefComplaintHint.
  ///
  /// In en, this message translates to:
  /// **'Main reason for visit'**
  String get encountersChiefComplaintHint;

  /// No description provided for @encountersChiefComplaintRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter chief complaint'**
  String get encountersChiefComplaintRequired;

  /// No description provided for @encountersNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinical Notes'**
  String get encountersNotesLabel;

  /// No description provided for @encountersNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Additional observations and notes'**
  String get encountersNotesHint;

  /// No description provided for @encountersSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Encounter saved successfully'**
  String get encountersSavedSuccess;

  /// No description provided for @encountersErrorMissingPatient.
  ///
  /// In en, this message translates to:
  /// **'Patient information is missing. Please select a patient first.'**
  String get encountersErrorMissingPatient;

  /// No description provided for @encountersErrorNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in to create an encounter.'**
  String get encountersErrorNotLoggedIn;

  /// No description provided for @encountersErrorMissingClinic.
  ///
  /// In en, this message translates to:
  /// **'Clinic information is missing. Please contact support.'**
  String get encountersErrorMissingClinic;

  /// No description provided for @encountersErrorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database error. Please check your connection and try again.'**
  String get encountersErrorDatabase;

  /// No description provided for @encountersErrorSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save encounter: {error}'**
  String encountersErrorSave(String error);

  /// No description provided for @encountersCloseTool.
  ///
  /// In en, this message translates to:
  /// **'Close Tool'**
  String get encountersCloseTool;

  /// No description provided for @encountersNoTools.
  ///
  /// In en, this message translates to:
  /// **'No tools available'**
  String get encountersNoTools;

  /// No description provided for @encountersNoToolsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tools will appear here when configured for this department'**
  String get encountersNoToolsSubtitle;

  /// No description provided for @encountersToolLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tool: {toolId}'**
  String encountersToolLoadError(String toolId);

  /// No description provided for @encountersDepartmentsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading departments...'**
  String get encountersDepartmentsLoading;

  /// No description provided for @encountersDepartmentsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load departments'**
  String get encountersDepartmentsLoadError;

  /// No description provided for @encountersDepartmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No departments available'**
  String get encountersDepartmentsEmpty;

  /// No description provided for @encountersDepartmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get encountersDepartmentLabel;

  /// No description provided for @formsStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get formsStatusLabel;

  /// No description provided for @formsStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get formsStatusAll;

  /// No description provided for @formsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get formsStatusActive;

  /// No description provided for @formsStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get formsStatusArchived;

  /// No description provided for @formsNoTemplatesFound.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get formsNoTemplatesFound;

  /// No description provided for @formsNoTemplatesSearch.
  ///
  /// In en, this message translates to:
  /// **'No templates match your search'**
  String get formsNoTemplatesSearch;

  /// No description provided for @formsNoTemplatesSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search terms'**
  String get formsNoTemplatesSearchSubtitle;

  /// No description provided for @formsDuplicateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template \"{name}\" duplicated successfully'**
  String formsDuplicateSuccess(String name);

  /// No description provided for @formsDuplicateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to duplicate template: {error}'**
  String formsDuplicateError(String error);

  /// No description provided for @formsArchiveConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive Template'**
  String get formsArchiveConfirmTitle;

  /// No description provided for @formsArchiveConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to archive \"{name}\"? It will no longer be available for new forms.'**
  String formsArchiveConfirmMessage(String name);

  /// No description provided for @formsArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get formsArchiveAction;

  /// No description provided for @formsArchiveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template \"{name}\" archived'**
  String formsArchiveSuccess(String name);

  /// No description provided for @formsArchiveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive template: {error}'**
  String formsArchiveError(String error);

  /// No description provided for @formsDetailsArchivedBadge.
  ///
  /// In en, this message translates to:
  /// **'ARCHIVED'**
  String get formsDetailsArchivedBadge;

  /// No description provided for @formsNoDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get formsNoDescription;

  /// No description provided for @formsPopupEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get formsPopupEdit;

  /// No description provided for @formsPopupDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get formsPopupDuplicate;

  /// No description provided for @formsPopupArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get formsPopupArchive;

  /// No description provided for @formsSectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get formsSectionsTitle;

  /// No description provided for @formsSectionsAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Section'**
  String get formsSectionsAddTooltip;

  /// No description provided for @formsSectionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No sections yet'**
  String get formsSectionsEmptyTitle;

  /// No description provided for @formsSectionsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a section to get started'**
  String get formsSectionsEmptySubtitle;

  /// No description provided for @formsQuestionsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Select a section to edit questions'**
  String get formsQuestionsPlaceholder;

  /// No description provided for @formsPreviewModeNotice.
  ///
  /// In en, this message translates to:
  /// **'Preview mode – inputs are disabled'**
  String get formsPreviewModeNotice;

  /// No description provided for @formsSectionIndexLabel.
  ///
  /// In en, this message translates to:
  /// **'Section {index}'**
  String formsSectionIndexLabel(int index);

  /// No description provided for @formsSectionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get formsSectionRename;

  /// No description provided for @formsSectionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get formsSectionDelete;

  /// No description provided for @formsSectionDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Section'**
  String get formsSectionDeleteTitle;

  /// No description provided for @formsSectionDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"? This will also delete all questions in this section.'**
  String formsSectionDeleteMessage(String name);

  /// No description provided for @formsUnsavedBadge.
  ///
  /// In en, this message translates to:
  /// **'UNSAVED'**
  String get formsUnsavedBadge;

  /// No description provided for @formsTemplateInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Template Information'**
  String get formsTemplateInfoTitle;

  /// No description provided for @formsTemplateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get formsTemplateNameLabel;

  /// No description provided for @formsTemplateNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a template name'**
  String get formsTemplateNameRequired;

  /// No description provided for @formsTemplateNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter template name'**
  String get formsTemplateNameHint;

  /// No description provided for @formsTemplateDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get formsTemplateDescriptionLabel;

  /// No description provided for @formsTemplateDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter template description'**
  String get formsTemplateDescriptionHint;

  /// No description provided for @formsSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template saved successfully'**
  String get formsSaveSuccess;

  /// No description provided for @formsSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save template: {error}'**
  String formsSaveError(String error);

  /// No description provided for @formsDiscardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get formsDiscardChangesTitle;

  /// No description provided for @formsDiscardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Do you want to discard them?'**
  String get formsDiscardChangesMessage;

  /// No description provided for @formsDiscardButton.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get formsDiscardButton;

  /// No description provided for @formsTabTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get formsTabTemplate;

  /// No description provided for @formsTabSections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get formsTabSections;

  /// No description provided for @formsTabPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get formsTabPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr', 'ht'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'ht':
      return AppLocalizationsHt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
