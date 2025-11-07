import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('ht'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'Dental EMR',
      'loginTitle': 'House of David',
      'loginSubtitle': 'FLM Haiti EMR',
      'loginTagline': 'Developed by CMU Heinz College Capstone Team',
      'emailLabel': 'Email',
      'emailRequiredError': 'Please enter email',
      'emailInvalidError': 'Please enter valid email',
      'passwordLabel': 'Password',
      'passwordRequiredError': 'Please enter password',
      'passwordLengthError': 'Password must be at least 6 characters',
      'signIn': 'Sign In',
      'forgotPassword': 'Forgot Password?',
      'signUpPrompt': "Don't have an account? ",
      'signUp': 'Sign Up',
      'dashboardTitle': 'Dashboard',
      'dashboardWelcome': 'House of David - Welcome Back!',
      'dashboardSubheading': 'Developed by CMU Heinz College Capstone Team',
      'patientsCardTitle': 'Patients',
      'patientsCardSubtitle': 'Manage patient records',
      'appointmentsCardTitle': 'Appointments',
      'appointmentsCardSubtitle': 'Schedule & manage',
      'encountersCardTitle': 'Encounters',
      'encountersCardSubtitle': 'Clinical exams',
      'formsCardTitle': 'Form Templates',
      'formsCardSubtitle': 'Manage questionnaires',
      'reportsCardTitle': 'Reports (In progress)',
      'reportsCardSubtitle': 'Analytics & insights',
      'recentActivity': 'Recent Activity',
      "todaysAppointments": "Today's Appointments",
      'pendingReviews': 'Pending Reviews',
      'newPatientsThisWeek': 'New Patients This Week',
      'languageSelectorLabel': 'Language',
      'languageEnglish': 'English',
      'languageFrench': 'French',
      'languageHaitianCreole': 'Haitian Creole',
      'genderMale': 'Male',
      'genderFemale': 'Female',
      'genderOther': 'Other',
      'patientsAddTitle': 'Add New Patient',
      'patientsNameLabel': 'Full Name',
      'patientsNameRequired': 'Please enter name',
      'patientsGenderLabel': 'Gender',
      'patientsGenderRequired': 'Please select gender',
      'patientsDobLabel': 'Date of Birth',
      'patientsDobPlaceholder': 'Select date',
      'patientsDobSelectPlaceholder': 'Select Date of Birth',
      'patientsPhoneLabel': 'Phone Number',
      'patientsPhoneRequired': 'Please enter phone',
      'patientsAddressLabel': 'Address',
      'patientsAddressRequired': 'Please enter address',
      'patientsBloodPressureLabel': 'Blood Pressure',
      'patientsBloodPressureHint': 'e.g., 120/80',
      'patientsBloodPressureOptionalLabel': 'Blood Pressure (optional)',
      'patientsSaveButton': 'Save Patient',
      'commonRequiredFieldsError': 'Please fill all required fields',
      'commonUserNotAuthenticated': 'User not authenticated',
      'patientsAddSuccess': 'Patient added successfully',
      'patientsAddError': 'Failed to add patient',
      'patientsDuplicateNameTitle': 'Duplicate Name Found',
      'patientsDuplicateNameMessage': 'The name "{name}" is already used by {count} patient(s). Continue saving?',
      'patientsDuplicateExisting': 'Existing patients:',
      'commonCancel': 'Cancel',
      'patientsDuplicateContinueButton': 'Yes, Save Anyway',
      'patientsDetailTitle': 'Patient Details',
      'patientsIdLabel': 'Patient ID',
      'patientsAgeLabel': 'Age',
      'patientsAgeYearsSuffix': 'years',
      'patientsBornLabel': 'Born:',
      'patientsQuickActions': 'Quick Actions',
      'patientsMedicalHistoryAction': 'Medical History',
      'patientsNewEncounterAction': 'New Encounter',
      'patientsQuestionnairesAction': 'Questionnaires',
      'patientsAppointmentsAction': 'Appointments',
      'patientsDocumentsAction': 'Documents',
      'patientsReportsAction': 'Reports',
      'patientsRecentEncounters': 'Recent Encounters',
      'patientsEncounterTypeRoutineCheckup': 'Routine Checkup',
      'patientsEncounterTypeDentalCleaning': 'Dental Cleaning',
      'patientsEncounterTypeToothExtraction': 'Tooth Extraction',
      'patientsNewButtonLabel': 'New Patient',
      'patientsSearchHint': 'Search patients...',
      'patientsLoadErrorTitle': 'Failed to load patients',
      'commonRetry': 'Retry',
      'patientsEmptyTitle': 'No patients found',
      'patientsEmptySubtitle': 'Add your first patient to get started',
      'patientsSearchNoResultsTitle': 'No patients match your search',
      'patientsSearchNoResultsSubtitle': 'Try adjusting your search terms',
      'patientsEditingTitle': 'Editing Patient',
      'patientsSaveChangesButton': 'Save Changes',
      'patientsUpdateSuccess': 'Patient updated successfully',
      'patientsUpdateError': 'Failed to update patient',
      'patientsDeleteTitle': 'Delete Patient',
      'patientsDeleteConfirmationMessage': 'Are you sure you want to delete {name}? This action cannot be undone.',
      'commonDelete': 'Delete',
      'patientsDeleteSuccess': 'Patient deleted successfully',
      'patientsDeleteError': 'Failed to delete patient',
    },
    'fr': {
      'appName': 'EMR Dentaire',
      'loginTitle': 'Maison de David',
      'loginSubtitle': 'FLM Haiti EMR',
      'loginTagline': "Développé par l'équipe Capstone du CMU Heinz College",
      'emailLabel': 'E-mail',
      'emailRequiredError': 'Veuillez saisir votre e-mail',
      'emailInvalidError': 'Veuillez saisir un e-mail valide',
      'passwordLabel': 'Mot de passe',
      'passwordRequiredError': 'Veuillez saisir votre mot de passe',
      'passwordLengthError': 'Le mot de passe doit contenir au moins 6 caractères',
      'signIn': 'Se connecter',
      'forgotPassword': 'Mot de passe oublié ?',
      'signUpPrompt': "Vous n'avez pas de compte ? ",
      'signUp': 'Inscrivez-vous',
      'dashboardTitle': 'Tableau de bord',
      'dashboardWelcome': 'Maison de David - Bon retour !',
      'dashboardSubheading': "Développé par l'équipe Capstone du CMU Heinz College",
      'patientsCardTitle': 'Patients',
      'patientsCardSubtitle': 'Gérer les dossiers patients',
      'appointmentsCardTitle': 'Rendez-vous',
      'appointmentsCardSubtitle': 'Planifier et gérer',
      'encountersCardTitle': 'Consultations',
      'encountersCardSubtitle': 'Examens cliniques',
      'formsCardTitle': 'Modèles de formulaires',
      'formsCardSubtitle': 'Gérer les questionnaires',
      'reportsCardTitle': 'Rapports (En cours)',
      'reportsCardSubtitle': 'Analyses et informations',
      'recentActivity': 'Activité récente',
      'todaysAppointments': 'Rendez-vous du jour',
      'pendingReviews': 'Revues en attente',
      'newPatientsThisWeek': 'Nouveaux patients cette semaine',
      'languageSelectorLabel': 'Langue',
      'languageEnglish': 'Anglais',
      'languageFrench': 'Français',
      'languageHaitianCreole': 'Créole haïtien',
      'genderMale': 'Homme',
      'genderFemale': 'Femme',
      'genderOther': 'Autre',
      'patientsAddTitle': 'Ajouter un nouveau patient',
      'patientsNameLabel': 'Nom complet',
      'patientsNameRequired': 'Veuillez saisir le nom',
      'patientsGenderLabel': 'Genre',
      'patientsGenderRequired': 'Veuillez sélectionner le genre',
      'patientsDobLabel': 'Date de naissance',
      'patientsDobPlaceholder': 'Sélectionner une date',
      'patientsDobSelectPlaceholder': 'Sélectionnez la date de naissance',
      'patientsPhoneLabel': 'Numéro de téléphone',
      'patientsPhoneRequired': 'Veuillez saisir le téléphone',
      'patientsAddressLabel': 'Adresse',
      'patientsAddressRequired': "Veuillez saisir l'adresse",
      'patientsBloodPressureLabel': 'Pression artérielle',
      'patientsBloodPressureHint': 'ex. 120/80',
      'patientsBloodPressureOptionalLabel': 'Pression artérielle (optionnel)',
      'patientsSaveButton': 'Enregistrer le patient',
      'commonRequiredFieldsError': 'Veuillez remplir tous les champs requis',
      'commonUserNotAuthenticated': 'Utilisateur non authentifié',
      'patientsAddSuccess': 'Patient ajouté avec succès',
      'patientsAddError': "Échec de l'ajout du patient",
      'patientsDuplicateNameTitle': 'Nom en double trouvé',
      'patientsDuplicateNameMessage': 'Le nom "{name}" est déjà utilisé par {count} patient(s). Continuer l\'enregistrement ?',
      'patientsDuplicateExisting': 'Patients existants :',
      'commonCancel': 'Annuler',
      'patientsDuplicateContinueButton': 'Oui, enregistrer quand même',
      'patientsDetailTitle': 'Détails du patient',
      'patientsIdLabel': 'ID patient',
      'patientsAgeLabel': 'Âge',
      'patientsAgeYearsSuffix': 'ans',
      'patientsBornLabel': 'Né(e) :',
      'patientsQuickActions': 'Actions rapides',
      'patientsMedicalHistoryAction': 'Historique médical',
      'patientsNewEncounterAction': 'Nouvelle consultation',
      'patientsQuestionnairesAction': 'Questionnaires',
      'patientsAppointmentsAction': 'Rendez-vous',
      'patientsDocumentsAction': 'Documents',
      'patientsReportsAction': 'Rapports',
      'patientsRecentEncounters': 'Consultations récentes',
      'patientsEncounterTypeRoutineCheckup': 'Contrôle de routine',
      'patientsEncounterTypeDentalCleaning': 'Nettoyage dentaire',
      'patientsEncounterTypeToothExtraction': 'Extraction dentaire',
      'patientsNewButtonLabel': 'Nouveau patient',
      'patientsSearchHint': 'Rechercher des patients...',
      'patientsLoadErrorTitle': 'Échec du chargement des patients',
      'commonRetry': 'Réessayer',
      'patientsEmptyTitle': 'Aucun patient trouvé',
      'patientsEmptySubtitle': 'Ajoutez votre premier patient pour commencer',
      'patientsSearchNoResultsTitle': 'Aucun patient ne correspond à votre recherche',
      'patientsSearchNoResultsSubtitle': "Essayez d'ajuster vos termes de recherche",
      'patientsEditingTitle': 'Modification du patient',
      'patientsSaveChangesButton': 'Enregistrer les modifications',
      'patientsUpdateSuccess': 'Patient mis à jour avec succès',
      'patientsUpdateError': 'Échec de la mise à jour du patient',
      'patientsDeleteTitle': 'Supprimer le patient',
      'patientsDeleteConfirmationMessage': 'Voulez-vous vraiment supprimer {name} ? Cette action est irréversible.',
      'commonDelete': 'Supprimer',
      'patientsDeleteSuccess': 'Patient supprimé avec succès',
      'patientsDeleteError': 'Échec de la suppression du patient',
    },
    'ht': {
      'appName': 'EMR Dantè',
      'loginTitle': 'House of David',
      'loginSubtitle': 'FLM Ayiti EMR',
      'loginTagline': 'Devlope pa ekip Capstone CMU Heinz College',
      'emailLabel': 'Imèl',
      'emailRequiredError': 'Tanpri antre imèl la',
      'emailInvalidError': 'Tanpri antre yon imèl ki valab',
      'passwordLabel': 'Modpas',
      'passwordRequiredError': 'Tanpri antre modpas la',
      'passwordLengthError': 'Modpas la dwe genyen omwen 6 karaktè',
      'signIn': 'Antre',
      'forgotPassword': 'Bliye modpas?',
      'signUpPrompt': 'Ou pa gen kont? ',
      'signUp': 'Enskri',
      'dashboardTitle': 'Tablo de Bord',
      'dashboardWelcome': 'House of David - Byen retounen!',
      'dashboardSubheading': 'Devlope pa ekip Capstone CMU Heinz College',
      'patientsCardTitle': 'Pasyan',
      'patientsCardSubtitle': 'Jere dosye pasyan yo',
      'appointmentsCardTitle': 'Randevou',
      'appointmentsCardSubtitle': 'Planifye ak jere',
      'encountersCardTitle': 'Vizit',
      'encountersCardSubtitle': 'Egzamen klinik',
      'formsCardTitle': 'Modèl Fòm',
      'formsCardSubtitle': 'Jere kesyonè yo',
      'reportsCardTitle': 'Rapò (An pwogrè)',
      'reportsCardSubtitle': 'Analiz ak enfòmasyon',
      'recentActivity': 'Aktivite resan',
      'todaysAppointments': 'Randevou jodi a',
      'pendingReviews': 'Revizyon an atant',
      'newPatientsThisWeek': 'Nouvo pasyan semèn sa a',
      'languageSelectorLabel': 'Lang',
      'languageEnglish': 'Anglè',
      'languageFrench': 'Franse',
      'languageHaitianCreole': 'Kreyòl Ayisyen',
      'genderMale': 'Gason',
      'genderFemale': 'Fi',
      'genderOther': 'Lòt',
      'patientsAddTitle': 'Ajoute Nouvo Pasyan',
      'patientsNameLabel': 'Non konplè',
      'patientsNameRequired': 'Tanpri antre non an',
      'patientsGenderLabel': 'Sèks',
      'patientsGenderRequired': 'Tanpri chwazi sèks',
      'patientsDobLabel': 'Dat nesans',
      'patientsDobPlaceholder': 'Chwazi dat',
      'patientsDobSelectPlaceholder': 'Chwazi dat nesans',
      'patientsPhoneLabel': 'Nimewo telefòn',
      'patientsPhoneRequired': 'Tanpri antre telefòn',
      'patientsAddressLabel': 'Adrès',
      'patientsAddressRequired': 'Tanpri antre adrès la',
      'patientsBloodPressureLabel': 'Tansyon',
      'patientsBloodPressureHint': 'egzanp, 120/80',
      'patientsBloodPressureOptionalLabel': 'Tansyon (opsyonèl)',
      'patientsSaveButton': 'Sove pasyan an',
      'commonRequiredFieldsError': 'Tanpri ranpli tout chan obligatwa yo',
      'commonUserNotAuthenticated': 'Itilizatè a pa otantifye',
      'patientsAddSuccess': 'Pasyan ajoute avèk siksè',
      'patientsAddError': 'Echwe pou ajoute pasyan an',
      'patientsDuplicateNameTitle': 'Nou jwenn yon non ki deja egziste',
      'patientsDuplicateNameMessage': 'Non "{name}" deja itilize pou {count} pasyan. Ou vle kontinye anrejistre?',
      'patientsDuplicateExisting': 'Pasyan ki deja egziste:',
      'commonCancel': 'Anile',
      'patientsDuplicateContinueButton': 'Wi, sove kanmenm',
      'patientsDetailTitle': 'Detay pasyan',
      'patientsIdLabel': 'ID pasyan',
      'patientsAgeLabel': 'Laj',
      'patientsAgeYearsSuffix': 'an',
      'patientsBornLabel': 'Fèt:',
      'patientsQuickActions': 'Aksyon rapid',
      'patientsMedicalHistoryAction': 'Istwa medikal',
      'patientsNewEncounterAction': 'Nouvo randevou',
      'patientsQuestionnairesAction': 'Kesyonè',
      'patientsAppointmentsAction': 'Randevou',
      'patientsDocumentsAction': 'Dokiman',
      'patientsReportsAction': 'Rapò',
      'patientsRecentEncounters': 'Vizit resan',
      'patientsEncounterTypeRoutineCheckup': 'Vizit woutin',
      'patientsEncounterTypeDentalCleaning': 'Netwayaj dan',
      'patientsEncounterTypeToothExtraction': 'Rale dan',
      'patientsNewButtonLabel': 'Nouvo pasyan',
      'patientsSearchHint': 'Chèche pasyan...',
      'patientsLoadErrorTitle': 'Nou pa kapab chaje pasyan yo',
      'commonRetry': 'Eseye ankò',
      'patientsEmptyTitle': 'Pa gen okenn pasyan',
      'patientsEmptySubtitle': 'Ajoute premye pasyan ou pou kòmanse',
      'patientsSearchNoResultsTitle': 'Pa gen pasyan ki matche rechèch ou',
      'patientsSearchNoResultsSubtitle': 'Eseye ajiste tèm rechèch ou',
      'patientsEditingTitle': 'Ap modifye pasyan an',
      'patientsSaveChangesButton': 'Sove chanjman yo',
      'patientsUpdateSuccess': 'Pasyan mete ajou avèk siksè',
      'patientsUpdateError': 'Echwe pou mete ajou pasyan an',
      'patientsDeleteTitle': 'Efase pasyan',
      'patientsDeleteConfirmationMessage': 'Èske ou sèten ou vle efase {name}? Aksyon sa a pa kapab anile.',
      'commonDelete': 'Efase',
      'patientsDeleteSuccess': 'Pasyan efase avèk siksè',
      'patientsDeleteError': 'Echwe pou efase pasyan an',
    },
  };

  String _translate(String key) {
    final values = _localizedValues[locale.languageCode];
    if (values != null && values.containsKey(key)) {
      return values[key]!;
    }
    return _localizedValues['en']![key] ?? key;
  }

  String get appName => _translate('appName');
  String get loginTitle => _translate('loginTitle');
  String get loginSubtitle => _translate('loginSubtitle');
  String get loginTagline => _translate('loginTagline');
  String get emailLabel => _translate('emailLabel');
  String get emailRequiredError => _translate('emailRequiredError');
  String get emailInvalidError => _translate('emailInvalidError');
  String get passwordLabel => _translate('passwordLabel');
  String get passwordRequiredError => _translate('passwordRequiredError');
  String get passwordLengthError => _translate('passwordLengthError');
  String get signIn => _translate('signIn');
  String get forgotPassword => _translate('forgotPassword');
  String get signUpPrompt => _translate('signUpPrompt');
  String get signUp => _translate('signUp');
  String get dashboardTitle => _translate('dashboardTitle');
  String get dashboardWelcome => _translate('dashboardWelcome');
  String get dashboardSubheading => _translate('dashboardSubheading');
  String get patientsCardTitle => _translate('patientsCardTitle');
  String get patientsCardSubtitle => _translate('patientsCardSubtitle');
  String get appointmentsCardTitle => _translate('appointmentsCardTitle');
  String get appointmentsCardSubtitle => _translate('appointmentsCardSubtitle');
  String get encountersCardTitle => _translate('encountersCardTitle');
  String get encountersCardSubtitle => _translate('encountersCardSubtitle');
  String get formsCardTitle => _translate('formsCardTitle');
  String get formsCardSubtitle => _translate('formsCardSubtitle');
  String get reportsCardTitle => _translate('reportsCardTitle');
  String get reportsCardSubtitle => _translate('reportsCardSubtitle');
  String get recentActivity => _translate('recentActivity');
  String get todaysAppointments => _translate('todaysAppointments');
  String get pendingReviews => _translate('pendingReviews');
  String get newPatientsThisWeek => _translate('newPatientsThisWeek');
  String get languageSelectorLabel => _translate('languageSelectorLabel');
  String get languageEnglish => _translate('languageEnglish');
  String get languageFrench => _translate('languageFrench');
  String get languageHaitianCreole => _translate('languageHaitianCreole');
  String get genderMale => _translate('genderMale');
  String get genderFemale => _translate('genderFemale');
  String get genderOther => _translate('genderOther');
  String get patientsAddTitle => _translate('patientsAddTitle');
  String get patientsNameLabel => _translate('patientsNameLabel');
  String get patientsNameRequired => _translate('patientsNameRequired');
  String get patientsGenderLabel => _translate('patientsGenderLabel');
  String get patientsGenderRequired => _translate('patientsGenderRequired');
  String get patientsDobLabel => _translate('patientsDobLabel');
  String get patientsDobPlaceholder => _translate('patientsDobPlaceholder');
  String get patientsDobSelectPlaceholder => _translate('patientsDobSelectPlaceholder');
  String get patientsPhoneLabel => _translate('patientsPhoneLabel');
  String get patientsPhoneRequired => _translate('patientsPhoneRequired');
  String get patientsAddressLabel => _translate('patientsAddressLabel');
  String get patientsAddressRequired => _translate('patientsAddressRequired');
  String get patientsBloodPressureLabel => _translate('patientsBloodPressureLabel');
  String get patientsBloodPressureHint => _translate('patientsBloodPressureHint');
  String get patientsBloodPressureOptionalLabel => _translate('patientsBloodPressureOptionalLabel');
  String get patientsSaveButton => _translate('patientsSaveButton');
  String get commonRequiredFieldsError => _translate('commonRequiredFieldsError');
  String get commonUserNotAuthenticated => _translate('commonUserNotAuthenticated');
  String get patientsAddSuccess => _translate('patientsAddSuccess');
  String get patientsAddError => _translate('patientsAddError');
  String get patientsDuplicateNameTitle => _translate('patientsDuplicateNameTitle');
  String get patientsDuplicateExisting => _translate('patientsDuplicateExisting');
  String get commonCancel => _translate('commonCancel');
  String get patientsDuplicateContinueButton => _translate('patientsDuplicateContinueButton');
  String get patientsDetailTitle => _translate('patientsDetailTitle');
  String get patientsIdLabel => _translate('patientsIdLabel');
  String get patientsAgeLabel => _translate('patientsAgeLabel');
  String get patientsAgeYearsSuffix => _translate('patientsAgeYearsSuffix');
  String get patientsBornLabel => _translate('patientsBornLabel');
  String get patientsQuickActions => _translate('patientsQuickActions');
  String get patientsMedicalHistoryAction => _translate('patientsMedicalHistoryAction');
  String get patientsNewEncounterAction => _translate('patientsNewEncounterAction');
  String get patientsQuestionnairesAction => _translate('patientsQuestionnairesAction');
  String get patientsAppointmentsAction => _translate('patientsAppointmentsAction');
  String get patientsDocumentsAction => _translate('patientsDocumentsAction');
  String get patientsReportsAction => _translate('patientsReportsAction');
  String get patientsRecentEncounters => _translate('patientsRecentEncounters');
  String get patientsEncounterTypeRoutineCheckup => _translate('patientsEncounterTypeRoutineCheckup');
  String get patientsEncounterTypeDentalCleaning => _translate('patientsEncounterTypeDentalCleaning');
  String get patientsEncounterTypeToothExtraction => _translate('patientsEncounterTypeToothExtraction');
  String get patientsNewButtonLabel => _translate('patientsNewButtonLabel');
  String get patientsSearchHint => _translate('patientsSearchHint');
  String get patientsLoadErrorTitle => _translate('patientsLoadErrorTitle');
  String get commonRetry => _translate('commonRetry');
  String get patientsEmptyTitle => _translate('patientsEmptyTitle');
  String get patientsEmptySubtitle => _translate('patientsEmptySubtitle');
  String get patientsSearchNoResultsTitle => _translate('patientsSearchNoResultsTitle');
  String get patientsSearchNoResultsSubtitle => _translate('patientsSearchNoResultsSubtitle');
  String get patientsEditingTitle => _translate('patientsEditingTitle');
  String get patientsSaveChangesButton => _translate('patientsSaveChangesButton');
  String get patientsUpdateSuccess => _translate('patientsUpdateSuccess');
  String get patientsUpdateError => _translate('patientsUpdateError');
  String get patientsDeleteTitle => _translate('patientsDeleteTitle');
  String get commonDelete => _translate('commonDelete');
  String get patientsDeleteSuccess => _translate('patientsDeleteSuccess');
  String get patientsDeleteError => _translate('patientsDeleteError');

  String patientsDuplicateNameMessage(String name, int count) {
    return _translate('patientsDuplicateNameMessage')
        .replaceFirst('{name}', name)
        .replaceFirst('{count}', '$count');
  }

  String patientsDeleteConfirmationMessage(String name) {
    return _translate('patientsDeleteConfirmationMessage')
        .replaceFirst('{name}', name);
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales
        .map((supported) => supported.languageCode)
        .contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
