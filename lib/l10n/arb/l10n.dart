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
