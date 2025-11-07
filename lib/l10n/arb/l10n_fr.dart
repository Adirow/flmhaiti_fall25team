// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'EMR Dentaire';

  @override
  String get loginTitle => 'Maison de David';

  @override
  String get loginSubtitle => 'FLM Haiti EMR';

  @override
  String get loginTagline =>
      'Développé par l\'équipe Capstone du CMU Heinz College';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get emailRequiredError => 'Veuillez saisir votre e-mail';

  @override
  String get emailInvalidError => 'Veuillez saisir un e-mail valide';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordRequiredError => 'Veuillez saisir votre mot de passe';

  @override
  String get passwordLengthError =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signIn => 'Se connecter';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signUpPrompt => 'Vous n\'avez pas de compte ? ';

  @override
  String get signUp => 'Inscrivez-vous';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get dashboardWelcome => 'Maison de David - Bon retour !';

  @override
  String get dashboardSubheading =>
      'Développé par l\'équipe Capstone du CMU Heinz College';

  @override
  String get patientsCardTitle => 'Patients';

  @override
  String get patientsCardSubtitle => 'Gérer les dossiers patients';

  @override
  String get appointmentsCardTitle => 'Rendez-vous';

  @override
  String get appointmentsCardSubtitle => 'Planifier et gérer';

  @override
  String get encountersCardTitle => 'Consultations';

  @override
  String get encountersCardSubtitle => 'Examens cliniques';

  @override
  String get formsCardTitle => 'Modèles de formulaires';

  @override
  String get formsCardSubtitle => 'Gérer les questionnaires';

  @override
  String get reportsCardTitle => 'Rapports (En cours)';

  @override
  String get reportsCardSubtitle => 'Analyses et informations';

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get todaysAppointments => 'Rendez-vous du jour';

  @override
  String get pendingReviews => 'Revues en attente';

  @override
  String get newPatientsThisWeek => 'Nouveaux patients cette semaine';

  @override
  String get languageSelectorLabel => 'Langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageHaitianCreole => 'Créole haïtien';

  @override
  String get genderMale => 'Homme';

  @override
  String get genderFemale => 'Femme';

  @override
  String get genderOther => 'Autre';

  @override
  String get patientsAddTitle => 'Ajouter un nouveau patient';

  @override
  String get patientsNameLabel => 'Nom complet';

  @override
  String get patientsNameRequired => 'Veuillez saisir le nom';

  @override
  String get patientsGenderLabel => 'Genre';

  @override
  String get patientsGenderRequired => 'Veuillez sélectionner le genre';

  @override
  String get patientsDobLabel => 'Date de naissance';

  @override
  String get patientsDobPlaceholder => 'Sélectionner une date';

  @override
  String get patientsDobSelectPlaceholder =>
      'Sélectionnez la date de naissance';

  @override
  String get patientsPhoneLabel => 'Numéro de téléphone';

  @override
  String get patientsPhoneRequired => 'Veuillez saisir le téléphone';

  @override
  String get patientsAddressLabel => 'Adresse';

  @override
  String get patientsAddressRequired => 'Veuillez saisir l\'adresse';

  @override
  String get patientsBloodPressureLabel => 'Pression artérielle';

  @override
  String get patientsBloodPressureHint => 'ex. 120/80';

  @override
  String get patientsBloodPressureOptionalLabel =>
      'Pression artérielle (optionnel)';

  @override
  String get patientsSaveButton => 'Enregistrer le patient';

  @override
  String get commonRequiredFieldsError =>
      'Veuillez remplir tous les champs requis';

  @override
  String get commonUserNotAuthenticated => 'Utilisateur non authentifié';

  @override
  String get patientsAddSuccess => 'Patient ajouté avec succès';

  @override
  String get patientsAddError => 'Échec de l\'ajout du patient';

  @override
  String get patientsDuplicateNameTitle => 'Nom en double trouvé';

  @override
  String patientsDuplicateNameMessage(Object count, Object name) {
    return 'Le nom \"$name\" est déjà utilisé par $count patient(s). Continuer l\'enregistrement ?';
  }

  @override
  String get patientsDuplicateExisting => 'Patients existants :';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get patientsDuplicateContinueButton => 'Oui, enregistrer quand même';

  @override
  String get patientsDetailTitle => 'Détails du patient';

  @override
  String get patientsIdLabel => 'ID patient';

  @override
  String get patientsAgeLabel => 'Âge';

  @override
  String get patientsAgeYearsSuffix => 'ans';

  @override
  String get patientsBornLabel => 'Né(e) :';

  @override
  String get patientsQuickActions => 'Actions rapides';

  @override
  String get patientsMedicalHistoryAction => 'Historique médical';

  @override
  String get patientsNewEncounterAction => 'Nouvelle consultation';

  @override
  String get patientsQuestionnairesAction => 'Questionnaires';

  @override
  String get patientsAppointmentsAction => 'Rendez-vous';

  @override
  String get patientsDocumentsAction => 'Documents';

  @override
  String get patientsReportsAction => 'Rapports';

  @override
  String get patientsRecentEncounters => 'Consultations récentes';

  @override
  String get patientsEncounterTypeRoutineCheckup => 'Contrôle de routine';

  @override
  String get patientsEncounterTypeDentalCleaning => 'Nettoyage dentaire';

  @override
  String get patientsEncounterTypeToothExtraction => 'Extraction dentaire';

  @override
  String get patientsNewButtonLabel => 'Nouveau patient';

  @override
  String get patientsSearchHint => 'Rechercher des patients...';

  @override
  String get patientsLoadErrorTitle => 'Échec du chargement des patients';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get patientsEmptyTitle => 'Aucun patient trouvé';

  @override
  String get patientsEmptySubtitle =>
      'Ajoutez votre premier patient pour commencer';

  @override
  String get patientsSearchNoResultsTitle =>
      'Aucun patient ne correspond à votre recherche';

  @override
  String get patientsSearchNoResultsSubtitle =>
      'Essayez d\'ajuster vos termes de recherche';

  @override
  String get patientsEditingTitle => 'Modification du patient';

  @override
  String get patientsSaveChangesButton => 'Enregistrer les modifications';

  @override
  String get patientsUpdateSuccess => 'Patient mis à jour avec succès';

  @override
  String get patientsUpdateError => 'Échec de la mise à jour du patient';

  @override
  String get patientsDeleteTitle => 'Supprimer le patient';

  @override
  String patientsDeleteConfirmationMessage(Object name) {
    return 'Voulez-vous vraiment supprimer $name ? Cette action est irréversible.';
  }

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get patientsDeleteSuccess => 'Patient supprimé avec succès';

  @override
  String get patientsDeleteError => 'Échec de la suppression du patient';
}
