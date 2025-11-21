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
  String get dashboardProfileTitle => 'Profil';

  @override
  String get dashboardProfileNameLabel => 'Nom de l\'utilisateur';

  @override
  String get dashboardProfileRoleLabel => 'Rôle';

  @override
  String get dashboardProfileEmailLabel => 'E-mail / Nom d\'utilisateur';

  @override
  String get dashboardProfileLogout => 'Se déconnecter';

  @override
  String get dashboardProfileLoading => 'Chargement du profil...';

  @override
  String get dashboardProfileError => 'Impossible de charger le profil';

  @override
  String get patientsCardTitle => 'Patients';

  @override
  String get patientsCardSubtitle => 'Gérer les dossiers patients';

  @override
  String get appointmentsCardTitle => 'Rendez-vous';

  @override
  String get appointmentsCardSubtitle => 'Planifier et gérer';

  @override
  String get appointmentsStatusScheduled => 'Planifié';

  @override
  String get appointmentsStatusConfirmed => 'Confirmé';

  @override
  String get appointmentsStatusInProgress => 'En cours';

  @override
  String get appointmentsStatusCompleted => 'Terminé';

  @override
  String get appointmentsStatusCancelled => 'Annulé';

  @override
  String get appointmentsFilterAll => 'Tous les rendez-vous';

  @override
  String get appointmentsEmptyTitle => 'Aucun rendez-vous trouvé';

  @override
  String get appointmentsEmptySubtitle =>
      'Appuyez sur le bouton + pour planifier un nouveau rendez-vous';

  @override
  String get appointmentsUnknownPatient => 'Patient inconnu';

  @override
  String get appointmentsActionConfirm => 'Confirmer';

  @override
  String get appointmentsActionEdit => 'Modifier';

  @override
  String get appointmentsActionReschedule => 'Reprogrammer';

  @override
  String get appointmentsActionStart => 'Commencer le rendez-vous';

  @override
  String get appointmentsActionComplete => 'Terminer';

  @override
  String get appointmentsNewButton => 'Nouveau rendez-vous';

  @override
  String get appointmentsSearchTitle => 'Rechercher des rendez-vous';

  @override
  String get appointmentsSearchLabel =>
      'Rechercher par nom de patient ou motif';

  @override
  String get appointmentsSearchButton => 'Rechercher';

  @override
  String appointmentsLoadError(Object error) {
    return 'Échec du chargement des rendez-vous : $error';
  }

  @override
  String appointmentsSearchError(Object error) {
    return 'Échec de la recherche de rendez-vous : $error';
  }

  @override
  String get appointmentsConfirmSuccess => 'Rendez-vous confirmé';

  @override
  String get appointmentsCancelSuccess => 'Rendez-vous annulé';

  @override
  String appointmentsActionError(Object action, Object error) {
    return 'Échec de $action du rendez-vous : $error';
  }

  @override
  String get appointmentsRescheduleTitle => 'Reprogrammer le rendez-vous';

  @override
  String appointmentsRescheduleDate(Object date) {
    return 'Date : $date';
  }

  @override
  String appointmentsRescheduleTime(Object time) {
    return 'Heure : $time';
  }

  @override
  String get appointmentsRescheduleSuccess => 'Rendez-vous reprogrammé';

  @override
  String appointmentsRescheduleError(Object error) {
    return 'Échec de la reprogrammation : $error';
  }

  @override
  String get appointmentsRescheduleButton => 'Reprogrammer';

  @override
  String get appointmentsDeleteTitle => 'Supprimer le rendez-vous';

  @override
  String get appointmentsDeleteMessage =>
      'Êtes-vous sûr de vouloir supprimer ce rendez-vous ? Cette action est irréversible.';

  @override
  String get appointmentsDeleteSuccess => 'Rendez-vous supprimé';

  @override
  String appointmentsDeleteError(Object error) {
    return 'Échec de la suppression du rendez-vous : $error';
  }

  @override
  String get appointmentsDetailTitle => 'Détails du rendez-vous';

  @override
  String appointmentsStatusUpdated(Object status) {
    return 'Statut du rendez-vous mis à jour vers $status';
  }

  @override
  String appointmentsStatusUpdateError(Object error) {
    return 'Échec de la mise à jour du statut : $error';
  }

  @override
  String appointmentsIdLabel(Object id) {
    return 'ID : $id...';
  }

  @override
  String get appointmentsPatientInformation => 'Informations sur le patient';

  @override
  String get appointmentsFieldName => 'Nom';

  @override
  String get appointmentsFieldPhone => 'Téléphone';

  @override
  String get appointmentsFieldAge => 'Âge';

  @override
  String appointmentsAgeValue(Object age) {
    return '$age ans';
  }

  @override
  String get appointmentsInformation => 'Informations sur le rendez-vous';

  @override
  String get appointmentsFieldReason => 'Motif';

  @override
  String get appointmentsFieldDate => 'Date';

  @override
  String get appointmentsFieldTime => 'Heure';

  @override
  String get appointmentsFieldDuration => 'Durée';

  @override
  String appointmentsDurationValue(Object minutes) {
    return '$minutes minutes';
  }

  @override
  String get appointmentsTimestamps => 'Horodatages';

  @override
  String get appointmentsFieldCreated => 'Créé';

  @override
  String get appointmentsFieldUpdated => 'Dernière mise à jour';

  @override
  String get appointmentsFormNewTitle => 'Nouveau rendez-vous';

  @override
  String get appointmentsFormEditTitle => 'Modifier le rendez-vous';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get appointmentsSelectPatientLabel => 'Sélectionner un patient';

  @override
  String get appointmentsSelectPatientError =>
      'Veuillez sélectionner un patient';

  @override
  String get appointmentsReasonLabel => 'Motif de la visite';

  @override
  String get appointmentsReasonError => 'Veuillez saisir le motif de la visite';

  @override
  String get appointmentsStatusLabel => 'Statut';

  @override
  String get appointmentsStartTimeLabel => 'Heure de début';

  @override
  String get appointmentsEndTimeLabel => 'Heure de fin';

  @override
  String get appointmentsCreateButton => 'Créer le rendez-vous';

  @override
  String get appointmentsUpdateButton => 'Mettre à jour le rendez-vous';

  @override
  String get appointmentsCreateSuccess => 'Rendez-vous créé avec succès';

  @override
  String get appointmentsUpdateSuccess => 'Rendez-vous mis à jour avec succès';

  @override
  String appointmentsSaveError(Object error) {
    return 'Échec de l\'enregistrement du rendez-vous : $error';
  }

  @override
  String get appointmentsEndTimeError =>
      'L\'heure de fin doit être après l\'heure de début';

  @override
  String appointmentsLoadPatientsError(Object error) {
    return 'Échec du chargement des patients : $error';
  }

  @override
  String appointmentsLoadPatientError(Object error) {
    return 'Échec du chargement du patient : $error';
  }

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

  @override
  String questionnairesTitle(Object patientName) {
    return 'Questionnaires - $patientName';
  }

  @override
  String get questionnairesLoadErrorTitle =>
      'Échec du chargement des questionnaires';

  @override
  String get questionnairesStartCardTitle =>
      'Commencer un nouveau questionnaire';

  @override
  String get questionnairesNoTemplates =>
      'Aucun modèle de questionnaire disponible';

  @override
  String get questionnairesSelectDepartment => 'Sélectionner un département';

  @override
  String questionnairesNoTemplatesForDepartment(String department) {
    return 'Aucun modèle disponible pour $department';
  }

  @override
  String get questionnairesSelectTemplate => 'Sélectionner un questionnaire';

  @override
  String get questionnairesStartButton => 'Démarrer le questionnaire';

  @override
  String get questionnairesPreviousTitle => 'Questionnaires précédents';

  @override
  String get questionnairesNoHistory => 'Aucun questionnaire précédent';

  @override
  String questionnairesStartError(String error) {
    return 'Échec du démarrage du questionnaire : $error';
  }

  @override
  String get questionnaireSavingLabel => 'Enregistrement...';

  @override
  String get questionnaireStatusSubmitted => 'SOUMIS';

  @override
  String get questionnaireStatusDraft => 'BROUILLON';

  @override
  String questionnaireAutoSaveFailed(String error) {
    return 'Échec de l\'enregistrement automatique : $error';
  }

  @override
  String get questionnaireSubmitSuccess => 'Questionnaire soumis avec succès !';

  @override
  String questionnaireSubmitError(String error) {
    return 'Échec de la soumission du questionnaire : $error';
  }

  @override
  String get questionnaireLoadErrorTitle =>
      'Échec du chargement du questionnaire';

  @override
  String get questionnaireEmptyTitle => 'Aucune question trouvée';

  @override
  String get questionnaireEmptySubtitle => 'Ce questionnaire semble vide';

  @override
  String get questionnaireSubmitButton => 'Soumettre le questionnaire';

  @override
  String get questionnaireSubmittedReadOnlyMessage =>
      'Ce questionnaire a été soumis et est désormais en lecture seule.';

  @override
  String questionnaireVersionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get questionnaireSelectDate => 'Sélectionner une date...';

  @override
  String get questionnaireTextHint => 'Entrez votre réponse...';

  @override
  String get questionnaireNumberHint => 'Entrez un nombre...';

  @override
  String get questionnaireChoiceHint => 'Sélectionnez une option...';

  @override
  String get questionnaireBooleanYes => 'Oui';

  @override
  String get encountersTitle => 'Consultations';

  @override
  String get encountersCreateNew => 'Nouvelle consultation';

  @override
  String get encountersContinue => 'Continuer';

  @override
  String get encountersStatusInProgress => 'En cours';

  @override
  String get encountersStatusCompleted => 'Terminée';

  @override
  String get encountersStatusDraft => 'Brouillon';

  @override
  String encountersLastUpdated(Object time) {
    return 'Dernière mise à jour $time';
  }

  @override
  String get encountersNoEncounters => 'Aucune consultation pour le moment';

  @override
  String get encountersNoEncountersSubtitle =>
      'Commencez en créant une nouvelle consultation';

  @override
  String get encountersLoadError => 'Échec du chargement des consultations';

  @override
  String encountersStartError(Object error) {
    return 'Échec du démarrage de la consultation : $error';
  }

  @override
  String get encountersDeleteConfirm => 'Supprimer la consultation ?';

  @override
  String get encountersDeleteMessage =>
      'Voulez-vous vraiment supprimer cette consultation ?';

  @override
  String get encountersDeleteSuccess => 'Consultation supprimée';

  @override
  String get encountersDeleteError =>
      'Échec de la suppression de la consultation';

  @override
  String get encountersToolsTitle => 'Outils cliniques';

  @override
  String get encountersToolVitals => 'Signes vitaux';

  @override
  String get encountersToolNotes => 'Notes';

  @override
  String get encountersToolMedications => 'Médicaments';

  @override
  String get encountersToolProcedures => 'Procédures';

  @override
  String get encountersSave => 'Enregistrer';

  @override
  String get encountersSubmit => 'Soumettre';

  @override
  String get encountersCancel => 'Annuler';

  @override
  String get formsTitle => 'Modèles de formulaires';

  @override
  String get formsCreateNew => 'Créer un modèle';

  @override
  String get formsEdit => 'Modifier';

  @override
  String get formsDelete => 'Supprimer';

  @override
  String get formsDuplicate => 'Dupliquer';

  @override
  String get formsPublish => 'Publier';

  @override
  String get formsUnpublish => 'Retirer';

  @override
  String get formsActiveBadge => 'Actif';

  @override
  String get formsDraftBadge => 'Brouillon';

  @override
  String get formsNoTemplates => 'Aucun modèle de formulaire';

  @override
  String get formsNoTemplatesSubtitle =>
      'Créez votre premier modèle pour commencer';

  @override
  String get formsSearchHint => 'Rechercher des modèles...';

  @override
  String formsLastUpdated(Object time) {
    return 'Dernière mise à jour $time';
  }

  @override
  String get formsLoadError => 'Échec du chargement des modèles';

  @override
  String get formsCreateSuccess => 'Modèle créé avec succès';

  @override
  String get formsCreateError => 'Échec de la création du modèle';

  @override
  String get formsUpdateSuccess => 'Modèle mis à jour avec succès';

  @override
  String get formsUpdateError => 'Échec de la mise à jour du modèle';

  @override
  String get formsDeleteConfirm => 'Supprimer le modèle ?';

  @override
  String get formsDeleteMessage => 'Voulez-vous vraiment supprimer ce modèle ?';

  @override
  String get formsDeleteSuccess => 'Modèle supprimé';

  @override
  String get formsDeleteError => 'Échec de la suppression du modèle';

  @override
  String get encountersLoadingTitle => 'Chargement...';

  @override
  String get encountersEditTitle => 'Modifier la consultation';

  @override
  String get encountersNewTitle => 'Nouvelle consultation';

  @override
  String get encountersInitErrorTitle =>
      'Échec de l\'initialisation de la consultation';

  @override
  String encountersInitError(String error) {
    return 'Échec de l\'initialisation de la consultation : $error';
  }

  @override
  String get encountersInfoSectionTitle => 'Informations sur la consultation';

  @override
  String get encountersExamTypeLabel => 'Type d\'examen';

  @override
  String get encountersChiefComplaintLabel => 'Motif principal';

  @override
  String get encountersChiefComplaintHint => 'Raison principale de la visite';

  @override
  String get encountersChiefComplaintRequired =>
      'Veuillez saisir le motif principal';

  @override
  String get encountersNotesLabel => 'Notes cliniques';

  @override
  String get encountersNotesHint => 'Observations et notes supplémentaires';

  @override
  String get encountersSavedSuccess => 'Consultation enregistrée avec succès';

  @override
  String get encountersErrorMissingPatient =>
      'Informations patient manquantes. Veuillez d\'abord sélectionner un patient.';

  @override
  String get encountersErrorNotLoggedIn =>
      'Veuillez vous connecter pour créer une consultation.';

  @override
  String get encountersErrorMissingClinic =>
      'Informations sur la clinique manquantes. Veuillez contacter le support.';

  @override
  String get encountersErrorDatabase =>
      'Erreur de base de données. Vérifiez votre connexion et réessayez.';

  @override
  String encountersErrorSave(String error) {
    return 'Échec de l\'enregistrement de la consultation : $error';
  }

  @override
  String get encountersCloseTool => 'Fermer l\'outil';

  @override
  String get encountersNoTools => 'Aucun outil disponible';

  @override
  String get encountersNoToolsSubtitle =>
      'Les outils apparaîtront ici lorsqu\'ils seront configurés pour ce service';

  @override
  String encountersToolLoadError(String toolId) {
    return 'Échec du chargement de l\'outil : $toolId';
  }

  @override
  String get encountersDepartmentsLoading => 'Chargement des services...';

  @override
  String get encountersDepartmentsLoadError =>
      'Échec du chargement des services';

  @override
  String get encountersDepartmentsEmpty => 'Aucun service disponible';

  @override
  String get encountersDepartmentLabel => 'Service';

  @override
  String get formsStatusLabel => 'Statut';

  @override
  String get formsStatusAll => 'Tous';

  @override
  String get formsStatusActive => 'Actifs';

  @override
  String get formsStatusArchived => 'Archivés';

  @override
  String get formsNoTemplatesFound => 'Aucun modèle trouvé';

  @override
  String get formsNoTemplatesSearch =>
      'Aucun modèle ne correspond à votre recherche';

  @override
  String get formsNoTemplatesSearchSubtitle =>
      'Essayez d\'ajuster vos termes de recherche';

  @override
  String formsDuplicateSuccess(String name) {
    return 'Modèle « $name » dupliqué avec succès';
  }

  @override
  String formsDuplicateError(String error) {
    return 'Échec de la duplication du modèle : $error';
  }

  @override
  String get formsArchiveConfirmTitle => 'Archiver le modèle';

  @override
  String formsArchiveConfirmMessage(String name) {
    return 'Voulez-vous vraiment archiver « $name » ? Il ne sera plus disponible pour de nouveaux formulaires.';
  }

  @override
  String get formsArchiveAction => 'Archiver';

  @override
  String formsArchiveSuccess(String name) {
    return 'Modèle « $name » archivé';
  }

  @override
  String formsArchiveError(String error) {
    return 'Échec de l\'archivage du modèle : $error';
  }

  @override
  String get formsDetailsArchivedBadge => 'ARCHIVÉ';

  @override
  String get formsNoDescription => 'Aucune description';

  @override
  String get formsPopupEdit => 'Modifier';

  @override
  String get formsPopupDuplicate => 'Dupliquer';

  @override
  String get formsPopupArchive => 'Archiver';

  @override
  String get formsSectionsTitle => 'Sections';

  @override
  String get formsSectionsAddTooltip => 'Ajouter une section';

  @override
  String get formsSectionsEmptyTitle => 'Aucune section pour le moment';

  @override
  String get formsSectionsEmptySubtitle => 'Ajoutez une section pour commencer';

  @override
  String get formsQuestionsPlaceholder =>
      'Sélectionnez une section pour modifier les questions';

  @override
  String get formsPreviewModeNotice =>
      'Mode aperçu – les champs sont désactivés';

  @override
  String formsSectionIndexLabel(int index) {
    return 'Section $index';
  }

  @override
  String get formsSectionRename => 'Renommer';

  @override
  String get formsSectionDelete => 'Supprimer';

  @override
  String get formsSectionDeleteTitle => 'Supprimer la section';

  @override
  String formsSectionDeleteMessage(String name) {
    return 'Voulez-vous vraiment supprimer « $name » ? Cela supprimera aussi toutes les questions de cette section.';
  }

  @override
  String get formsUnsavedBadge => 'NON ENREGISTRÉ';

  @override
  String get formsTemplateInfoTitle => 'Informations sur le modèle';

  @override
  String get formsTemplateNameLabel => 'Nom du modèle';

  @override
  String get formsTemplateNameRequired => 'Veuillez saisir un nom de modèle';

  @override
  String get formsTemplateNameHint => 'Saisissez le nom du modèle';

  @override
  String get formsTemplateDescriptionLabel => 'Description';

  @override
  String get formsTemplateDescriptionHint => 'Entrez la description du modèle';

  @override
  String get formsSaveSuccess => 'Modèle enregistré avec succès';

  @override
  String formsSaveError(String error) {
    return 'Échec de l\'enregistrement du modèle : $error';
  }

  @override
  String get formsDiscardChangesTitle => 'Modifications non enregistrées';

  @override
  String get formsDiscardChangesMessage =>
      'Vous avez des modifications non enregistrées. Voulez-vous les abandonner ?';

  @override
  String get formsDiscardButton => 'Abandonner';

  @override
  String get formsTabTemplate => 'Modèle';

  @override
  String get formsTabSections => 'Sections';

  @override
  String get formsTabPreview => 'Aperçu';
}
