// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Haitian Haitian Creole (`ht`).
class AppLocalizationsHt extends AppLocalizations {
  AppLocalizationsHt([String locale = 'ht']) : super(locale);

  @override
  String get appName => 'EMR Dantè';

  @override
  String get loginTitle => 'House of David';

  @override
  String get loginSubtitle => 'FLM Ayiti EMR';

  @override
  String get loginTagline => 'Devlope pa ekip Capstone CMU Heinz College';

  @override
  String get emailLabel => 'Imèl';

  @override
  String get emailRequiredError => 'Tanpri antre imèl la';

  @override
  String get emailInvalidError => 'Tanpri antre yon imèl ki valab';

  @override
  String get passwordLabel => 'Modpas';

  @override
  String get passwordRequiredError => 'Tanpri antre modpas la';

  @override
  String get passwordLengthError => 'Modpas la dwe genyen omwen 6 karaktè';

  @override
  String get signIn => 'Antre';

  @override
  String get forgotPassword => 'Bliye modpas?';

  @override
  String get signUpPrompt => 'Ou pa gen kont? ';

  @override
  String get signUp => 'Enskri';

  @override
  String get dashboardTitle => 'Tablo de Bord';

  @override
  String get dashboardWelcome => 'House of David - Byen retounen!';

  @override
  String get dashboardSubheading =>
      'Devlope pa ekip Capstone CMU Heinz College';

  @override
  String get dashboardProfileTitle => 'Pwofil';

  @override
  String get dashboardProfileNameLabel => 'Non itilizatè';

  @override
  String get dashboardProfileRoleLabel => 'Wòl';

  @override
  String get dashboardProfileEmailLabel => 'Imèl / Non itilizatè';

  @override
  String get dashboardProfileLogout => 'Dekonekte';

  @override
  String get dashboardProfileLoading => 'Ap chaje pwofil la...';

  @override
  String get dashboardProfileError => 'Pa kapab chaje pwofil la';

  @override
  String get patientsCardTitle => 'Pasyan';

  @override
  String get patientsCardSubtitle => 'Jere dosye pasyan yo';

  @override
  String get appointmentsCardTitle => 'Randevou';

  @override
  String get appointmentsCardSubtitle => 'Planifye ak jere';

  @override
  String get appointmentsStatusScheduled => 'Pwograme';

  @override
  String get appointmentsStatusConfirmed => 'Konfime';

  @override
  String get appointmentsStatusInProgress => 'An pwogrè';

  @override
  String get appointmentsStatusCompleted => 'Fini';

  @override
  String get appointmentsStatusCancelled => 'Anile';

  @override
  String get appointmentsFilterAll => 'Tout randevou yo';

  @override
  String get appointmentsEmptyTitle => 'Pa gen okenn randevou';

  @override
  String get appointmentsEmptySubtitle =>
      'Peze bouton + pou pwograme yon nouvo randevou';

  @override
  String get appointmentsUnknownPatient => 'Pasyan enkoni';

  @override
  String get appointmentsActionConfirm => 'Konfime';

  @override
  String get appointmentsActionEdit => 'Modifye';

  @override
  String get appointmentsActionReschedule => 'Repwograme';

  @override
  String get appointmentsActionStart => 'Kòmanse randevou';

  @override
  String get appointmentsActionComplete => 'Fini';

  @override
  String get appointmentsNewButton => 'Nouvo randevou';

  @override
  String get appointmentsSearchTitle => 'Chèche randevou';

  @override
  String get appointmentsSearchLabel => 'Chèche pa non pasyan oswa rezon';

  @override
  String get appointmentsSearchButton => 'Chèche';

  @override
  String appointmentsLoadError(Object error) {
    return 'Echwe pou chaje randevou yo : $error';
  }

  @override
  String appointmentsSearchError(Object error) {
    return 'Echwe pou chèche randevou yo : $error';
  }

  @override
  String get appointmentsConfirmSuccess => 'Randevou konfime';

  @override
  String get appointmentsCancelSuccess => 'Randevou anile';

  @override
  String appointmentsActionError(Object action, Object error) {
    return 'Echwe pou $action randevou a : $error';
  }

  @override
  String get appointmentsRescheduleTitle => 'Repwograme randevou a';

  @override
  String appointmentsRescheduleDate(Object date) {
    return 'Dat : $date';
  }

  @override
  String appointmentsRescheduleTime(Object time) {
    return 'Lè : $time';
  }

  @override
  String get appointmentsRescheduleSuccess => 'Randevou replanifye';

  @override
  String appointmentsRescheduleError(Object error) {
    return 'Echwe pou replanifye : $error';
  }

  @override
  String get appointmentsRescheduleButton => 'Repwograme';

  @override
  String get appointmentsDeleteTitle => 'Efase randevou a';

  @override
  String get appointmentsDeleteMessage =>
      'Èske w sèten ou vle efase randevou sa a? Aksyon sa a pap ka defèt.';

  @override
  String get appointmentsDeleteSuccess => 'Randevou efase';

  @override
  String appointmentsDeleteError(Object error) {
    return 'Echwe pou efase randevou a : $error';
  }

  @override
  String get appointmentsDetailTitle => 'Detay randevou';

  @override
  String appointmentsStatusUpdated(Object status) {
    return 'Estati randevou a mete ajou kòm $status';
  }

  @override
  String appointmentsStatusUpdateError(Object error) {
    return 'Echwe pou mete ajou estati a : $error';
  }

  @override
  String appointmentsIdLabel(Object id) {
    return 'ID : $id...';
  }

  @override
  String get appointmentsPatientInformation => 'Enfòmasyon pasyan';

  @override
  String get appointmentsFieldName => 'Non';

  @override
  String get appointmentsFieldPhone => 'Telefòn';

  @override
  String get appointmentsFieldAge => 'Laj';

  @override
  String appointmentsAgeValue(Object age) {
    return '$age an';
  }

  @override
  String get appointmentsInformation => 'Enfòmasyon sou randevou';

  @override
  String get appointmentsFieldReason => 'Rezon';

  @override
  String get appointmentsFieldDate => 'Dat';

  @override
  String get appointmentsFieldTime => 'Lè';

  @override
  String get appointmentsFieldDuration => 'Dire';

  @override
  String appointmentsDurationValue(Object minutes) {
    return '$minutes minit';
  }

  @override
  String get appointmentsTimestamps => 'Anrejistreman tan';

  @override
  String get appointmentsFieldCreated => 'Kreye';

  @override
  String get appointmentsFieldUpdated => 'Dènye aktyalizasyon';

  @override
  String get appointmentsFormNewTitle => 'Nouvo randevou';

  @override
  String get appointmentsFormEditTitle => 'Modifye randevou a';

  @override
  String get commonSave => 'Sove';

  @override
  String get appointmentsSelectPatientLabel => 'Chwazi yon pasyan';

  @override
  String get appointmentsSelectPatientError => 'Tanpri chwazi yon pasyan';

  @override
  String get appointmentsReasonLabel => 'Rezon vizit la';

  @override
  String get appointmentsReasonError => 'Tanpri antre rezon vizit la';

  @override
  String get appointmentsStatusLabel => 'Estati';

  @override
  String get appointmentsStartTimeLabel => 'Lè kòmanse';

  @override
  String get appointmentsEndTimeLabel => 'Lè fini';

  @override
  String get appointmentsCreateButton => 'Kreye randevou';

  @override
  String get appointmentsUpdateButton => 'Mete ajou randevou a';

  @override
  String get appointmentsCreateSuccess => 'Randevou kreye avèk siksè';

  @override
  String get appointmentsUpdateSuccess => 'Randevou mete ajou avèk siksè';

  @override
  String appointmentsSaveError(Object error) {
    return 'Echwe pou sove randevou a : $error';
  }

  @override
  String get appointmentsEndTimeError => 'Lè fini an dwe apre lè kòmanse a';

  @override
  String appointmentsLoadPatientsError(Object error) {
    return 'Echwe pou chaje pasyan yo : $error';
  }

  @override
  String appointmentsLoadPatientError(Object error) {
    return 'Echwe pou chaje pasyan an : $error';
  }

  @override
  String get encountersCardTitle => 'Vizit';

  @override
  String get encountersCardSubtitle => 'Egzamen klinik';

  @override
  String get formsCardTitle => 'Modèl Fòm';

  @override
  String get formsCardSubtitle => 'Jere kesyonè yo';

  @override
  String get reportsCardTitle => 'Rapò (An pwogrè)';

  @override
  String get reportsCardSubtitle => 'Analiz ak enfòmasyon';

  @override
  String get recentActivity => 'Aktivite resan';

  @override
  String get todaysAppointments => 'Randevou jodi a';

  @override
  String get pendingReviews => 'Revizyon an atant';

  @override
  String get newPatientsThisWeek => 'Nouvo pasyan semèn sa a';

  @override
  String get languageSelectorLabel => 'Lang';

  @override
  String get languageEnglish => 'Anglè';

  @override
  String get languageFrench => 'Franse';

  @override
  String get languageHaitianCreole => 'Kreyòl Ayisyen';

  @override
  String get genderMale => 'Gason';

  @override
  String get genderFemale => 'Fi';

  @override
  String get genderOther => 'Lòt';

  @override
  String get patientsAddTitle => 'Ajoute Nouvo Pasyan';

  @override
  String get patientsNameLabel => 'Non konplè';

  @override
  String get patientsNameRequired => 'Tanpri antre non an';

  @override
  String get patientsGenderLabel => 'Sèks';

  @override
  String get patientsGenderRequired => 'Tanpri chwazi sèks';

  @override
  String get patientsDobLabel => 'Dat nesans';

  @override
  String get patientsDobPlaceholder => 'Chwazi dat';

  @override
  String get patientsDobSelectPlaceholder => 'Chwazi dat nesans';

  @override
  String get patientsPhoneLabel => 'Nimewo telefòn';

  @override
  String get patientsPhoneRequired => 'Tanpri antre telefòn';

  @override
  String get patientsAddressLabel => 'Adrès';

  @override
  String get patientsAddressRequired => 'Tanpri antre adrès la';

  @override
  String get patientsBloodPressureLabel => 'Tansyon';

  @override
  String get patientsBloodPressureHint => 'egzanp, 120/80';

  @override
  String get patientsBloodPressureOptionalLabel => 'Tansyon (opsyonèl)';

  @override
  String get patientsSaveButton => 'Sove pasyan an';

  @override
  String get commonRequiredFieldsError =>
      'Tanpri ranpli tout chan obligatwa yo';

  @override
  String get commonUserNotAuthenticated => 'Itilizatè a pa otantifye';

  @override
  String get patientsAddSuccess => 'Pasyan ajoute avèk siksè';

  @override
  String get patientsAddError => 'Echwe pou ajoute pasyan an';

  @override
  String get patientsDuplicateNameTitle => 'Nou jwenn yon non ki deja egziste';

  @override
  String patientsDuplicateNameMessage(Object count, Object name) {
    return 'Non \"$name\" deja itilize pou $count pasyan. Ou vle kontinye anrejistre?';
  }

  @override
  String get patientsDuplicateExisting => 'Pasyan ki deja egziste:';

  @override
  String get commonCancel => 'Anile';

  @override
  String get patientsDuplicateContinueButton => 'Wi, sove kanmenm';

  @override
  String get patientsDetailTitle => 'Detay pasyan';

  @override
  String get patientsIdLabel => 'ID pasyan';

  @override
  String get patientsAgeLabel => 'Laj';

  @override
  String get patientsAgeYearsSuffix => 'an';

  @override
  String get patientsBornLabel => 'Fèt:';

  @override
  String get patientsQuickActions => 'Aksyon rapid';

  @override
  String get patientsMedicalHistoryAction => 'Istwa medikal';

  @override
  String get patientsNewEncounterAction => 'Nouvo randevou';

  @override
  String get patientsQuestionnairesAction => 'Kesyonè';

  @override
  String get patientsAppointmentsAction => 'Randevou';

  @override
  String get patientsDocumentsAction => 'Dokiman';

  @override
  String get patientsReportsAction => 'Rapò';

  @override
  String get patientsRecentEncounters => 'vizit resan';

  @override
  String get patientsEncounterTypeRoutineCheckup => 'Vizit woutin';

  @override
  String get patientsEncounterTypeDentalCleaning => 'Netwayaj dan';

  @override
  String get patientsEncounterTypeToothExtraction => 'Rale dan';

  @override
  String get patientsNewButtonLabel => 'Nouvo pasyan';

  @override
  String get patientsSearchHint => 'Chèche pasyan...';

  @override
  String get patientsLoadErrorTitle => 'Nou pa kapab chaje pasyan yo';

  @override
  String get commonRetry => 'Eseye ankò';

  @override
  String get patientsEmptyTitle => 'Pa gen okenn pasyan';

  @override
  String get patientsEmptySubtitle => 'Ajoute premye pasyan ou pou kòmanse';

  @override
  String get patientsSearchNoResultsTitle =>
      'Pa gen pasyan ki matche rechèch ou';

  @override
  String get patientsSearchNoResultsSubtitle => 'Eseye ajiste tèm rechèch ou';

  @override
  String get patientsEditingTitle => 'Ap modifye pasyan an';

  @override
  String get patientsSaveChangesButton => 'Sove chanjman yo';

  @override
  String get patientsUpdateSuccess => 'Pasyan mete ajou avèk siksè';

  @override
  String get patientsUpdateError => 'Echwe pou mete ajou pasyan an';

  @override
  String get patientsDeleteTitle => 'Efase pasyan';

  @override
  String patientsDeleteConfirmationMessage(Object name) {
    return 'Èske ou sèten ou vle efase $name? Aksyon sa a pa kapab anile.';
  }

  @override
  String get commonDelete => 'Efase';

  @override
  String get patientsDeleteSuccess => 'Pasyan efase avèk siksè';

  @override
  String get patientsDeleteError => 'Echwe pou efase pasyan an';

  @override
  String questionnairesTitle(Object patientName) {
    return 'Kesyonè - $patientName';
  }

  @override
  String get questionnairesLoadErrorTitle => 'Pa t kapab chaje kesyonè yo';

  @override
  String get questionnairesStartCardTitle => 'Kòmanse nouvo kesyonè';

  @override
  String get questionnairesNoTemplates => 'Pa gen modèl kesyonè disponib';

  @override
  String get questionnairesSelectDepartment => 'Chwazi depatman';

  @override
  String questionnairesNoTemplatesForDepartment(String department) {
    return 'Pa gen modèl disponib pou $department';
  }

  @override
  String get questionnairesSelectTemplate => 'Chwazi kesyonè';

  @override
  String get questionnairesStartButton => 'Kòmanse kesyonè a';

  @override
  String get questionnairesPreviousTitle => 'Kesyonè anvan yo';

  @override
  String get questionnairesNoHistory => 'Pa gen okenn kesyonè anvan';

  @override
  String questionnairesStartError(String error) {
    return 'Echwe pou kòmanse kesyonè a : $error';
  }

  @override
  String get questionnaireSavingLabel => 'Ap sove...';

  @override
  String get questionnaireStatusSubmitted => 'SOUMÈT';

  @override
  String get questionnaireStatusDraft => 'BROUYON';

  @override
  String questionnaireAutoSaveFailed(String error) {
    return 'Auto-sove echwe : $error';
  }

  @override
  String get questionnaireSubmitSuccess => 'Kesyonè a soumèt ak siksè!';

  @override
  String questionnaireSubmitError(String error) {
    return 'Echwe pou soumèt kesyonè a : $error';
  }

  @override
  String get questionnaireLoadErrorTitle => 'Pa t kapab chaje kesyonè a';

  @override
  String get questionnaireEmptyTitle => 'Pa jwenn okenn kesyon';

  @override
  String get questionnaireEmptySubtitle => 'Kesyonè sa a sanble vid';

  @override
  String get questionnaireSubmitButton => 'Soumèt kesyonè a';

  @override
  String get questionnaireSubmittedReadOnlyMessage =>
      'Kesyonè sa a deja soumèt epi kounye a li sèlman pou lekti.';

  @override
  String questionnaireVersionLabel(String version) {
    return 'Vèsyon $version';
  }

  @override
  String get questionnaireSelectDate => 'Chwazi dat...';

  @override
  String get questionnaireTextHint => 'Antre repons ou...';

  @override
  String get questionnaireNumberHint => 'Antre yon nimewo...';

  @override
  String get questionnaireChoiceHint => 'Chwazi yon opsyon...';

  @override
  String get questionnaireBooleanYes => 'Wi';

  @override
  String get encountersTitle => 'Vizit';

  @override
  String get encountersCreateNew => 'Nouvo vizit';

  @override
  String get encountersContinue => 'Kontinye';

  @override
  String get encountersStatusInProgress => 'An pwogrè';

  @override
  String get encountersStatusCompleted => 'Fini';

  @override
  String get encountersStatusDraft => 'Brouyon';

  @override
  String encountersLastUpdated(Object time) {
    return 'Dènye mizajou $time';
  }

  @override
  String get encountersNoEncounters => 'Poko gen okenn vizit';

  @override
  String get encountersNoEncountersSubtitle =>
      'Kòmanse pa kreye yon nouvo vizit';

  @override
  String get encountersLoadError => 'Echwe pou chaje vizit yo';

  @override
  String encountersStartError(Object error) {
    return 'Echwe pou kòmanse vizit la : $error';
  }

  @override
  String get encountersDeleteConfirm => 'Efase vizit la?';

  @override
  String get encountersDeleteMessage => 'Èske ou vle vrèman efase vizit sa a?';

  @override
  String get encountersDeleteSuccess => 'Vizit efase';

  @override
  String get encountersDeleteError => 'Echwe pou efase vizit la';

  @override
  String get encountersToolsTitle => 'Zouti klinik';

  @override
  String get encountersToolVitals => 'Siy vital';

  @override
  String get encountersToolNotes => 'Nòt';

  @override
  String get encountersToolMedications => 'Medikaman';

  @override
  String get encountersToolProcedures => 'Pwosedi';

  @override
  String get encountersSave => 'Sove';

  @override
  String get encountersSubmit => 'Soumèt';

  @override
  String get encountersCancel => 'Anile';

  @override
  String get formsTitle => 'Modèl fòm';

  @override
  String get formsCreateNew => 'Kreye modèl';

  @override
  String get formsEdit => 'Modifye';

  @override
  String get formsDelete => 'Efase';

  @override
  String get formsDuplicate => 'Duplike';

  @override
  String get formsPublish => 'Pibliye';

  @override
  String get formsUnpublish => 'Retire';

  @override
  String get formsActiveBadge => 'Aktif';

  @override
  String get formsDraftBadge => 'Brouyon';

  @override
  String get formsNoTemplates => 'Pa gen okenn modèl fòm';

  @override
  String get formsNoTemplatesSubtitle => 'Kreye premye modèl ou pou kòmanse';

  @override
  String get formsSearchHint => 'Chèche modèl...';

  @override
  String formsLastUpdated(Object time) {
    return 'Dènye mizajou $time';
  }

  @override
  String get formsLoadError => 'Echwe pou chaje modèl yo';

  @override
  String get formsCreateSuccess => 'Modèl kreye avèk siksè';

  @override
  String get formsCreateError => 'Echwe pou kreye modèl la';

  @override
  String get formsUpdateSuccess => 'Modèl mete ajou avèk siksè';

  @override
  String get formsUpdateError => 'Echwe pou mete ajou modèl la';

  @override
  String get formsDeleteConfirm => 'Efase modèl la?';

  @override
  String get formsDeleteMessage => 'Èske ou vle vrèman efase modèl sa a?';

  @override
  String get formsDeleteSuccess => 'Modèl efase';

  @override
  String get formsDeleteError => 'Echwe pou efase modèl la';

  @override
  String get encountersLoadingTitle => 'Ap chaje...';

  @override
  String get encountersEditTitle => 'Modifye vizit';

  @override
  String get encountersNewTitle => 'Nouvo vizit';

  @override
  String get encountersInitErrorTitle => 'Pa t kapab inisyalize vizit la';

  @override
  String encountersInitError(String error) {
    return 'Pa t kapab inisyalize vizit la : $error';
  }

  @override
  String get encountersInfoSectionTitle => 'Enfòmasyon sou vizit la';

  @override
  String get encountersExamTypeLabel => 'Kalite egzamen';

  @override
  String get encountersChiefComplaintLabel => 'Rezon prensipal';

  @override
  String get encountersChiefComplaintHint => 'Rezon prensipal vizit la';

  @override
  String get encountersChiefComplaintRequired =>
      'Tanpri antre rezon prensipal la';

  @override
  String get encountersNotesLabel => 'Nòt klinik';

  @override
  String get encountersNotesHint => 'Obsèvasyon ak nòt siplemantè';

  @override
  String get encountersSavedSuccess => 'Vizit sove avèk siksè';

  @override
  String get encountersErrorMissingPatient =>
      'Enfòmasyon pasyan an pa disponib. Tanpri chwazi yon pasyan anvan.';

  @override
  String get encountersErrorNotLoggedIn =>
      'Tanpri konekte pou kreye yon vizit.';

  @override
  String get encountersErrorMissingClinic =>
      'Enfòmasyon sou klinik la manke. Tanpri kontakte sipò.';

  @override
  String get encountersErrorDatabase =>
      'Erè baz done. Tanpri tcheke koneksyon ou epi eseye ankò.';

  @override
  String encountersErrorSave(String error) {
    return 'Echwe pou sove vizit la : $error';
  }

  @override
  String get encountersCloseTool => 'Fèmen zouti a';

  @override
  String get encountersNoTools => 'Pa gen okenn zouti disponib';

  @override
  String get encountersNoToolsSubtitle =>
      'Zouti yo ap parèt isit la lè yo konfigire pou depatman sa a';

  @override
  String encountersToolLoadError(String toolId) {
    return 'Echwe pou chaje zouti a : $toolId';
  }

  @override
  String get encountersDepartmentsLoading => 'Ap chaje depatman yo...';

  @override
  String get encountersDepartmentsLoadError => 'Echwe pou chaje depatman yo';

  @override
  String get encountersDepartmentsEmpty => 'Pa gen okenn depatman disponib';

  @override
  String get encountersDepartmentLabel => 'Depatman';

  @override
  String get formsStatusLabel => 'Estati';

  @override
  String get formsStatusAll => 'Tout';

  @override
  String get formsStatusActive => 'Aktif';

  @override
  String get formsStatusArchived => 'Achive';

  @override
  String get formsNoTemplatesFound => 'Pa jwenn okenn modèl';

  @override
  String get formsNoTemplatesSearch =>
      'Pa gen okenn modèl ki matche rechèch ou';

  @override
  String get formsNoTemplatesSearchSubtitle => 'Eseye ajiste tèm rechèch ou';

  @override
  String formsDuplicateSuccess(String name) {
    return 'Modèl \"$name\" duplike avèk siksè';
  }

  @override
  String formsDuplicateError(String error) {
    return 'Echwe pou duplike modèl la : $error';
  }

  @override
  String get formsArchiveConfirmTitle => 'Achive modèl la';

  @override
  String formsArchiveConfirmMessage(String name) {
    return 'Èske ou vle achive \"$name\"? Li pap disponib ankò pou nouvo fòm.';
  }

  @override
  String get formsArchiveAction => 'Achive';

  @override
  String formsArchiveSuccess(String name) {
    return 'Modèl \"$name\" achive';
  }

  @override
  String formsArchiveError(String error) {
    return 'Echwe pou achive modèl la : $error';
  }

  @override
  String get formsDetailsArchivedBadge => 'ACHIVE';

  @override
  String get formsNoDescription => 'Pa gen deskripsyon';

  @override
  String get formsPopupEdit => 'Modifye';

  @override
  String get formsPopupDuplicate => 'Duplike';

  @override
  String get formsPopupArchive => 'Achive';

  @override
  String get formsSectionsTitle => 'Seksyon yo';

  @override
  String get formsSectionsAddTooltip => 'Ajoute seksyon';

  @override
  String get formsSectionsEmptyTitle => 'Poko gen okenn seksyon';

  @override
  String get formsSectionsEmptySubtitle => 'Ajoute yon seksyon pou kòmanse';

  @override
  String get formsQuestionsPlaceholder =>
      'Chwazi yon seksyon pou modifye kesyon yo';

  @override
  String get formsPreviewModeNotice => 'Mòd aperçu – chan yo dezaktive';

  @override
  String formsSectionIndexLabel(int index) {
    return 'Seksyon $index';
  }

  @override
  String get formsSectionRename => 'Renome';

  @override
  String get formsSectionDelete => 'Efase';

  @override
  String get formsSectionDeleteTitle => 'Efase seksyon an';

  @override
  String formsSectionDeleteMessage(String name) {
    return 'Èske ou vle efase \"$name\"? Sa ap efase tou tout kesyon ki nan seksyon sa a.';
  }

  @override
  String get formsUnsavedBadge => 'PA SOVE';

  @override
  String get formsTemplateInfoTitle => 'Enfòmasyon sou modèl la';

  @override
  String get formsTemplateNameLabel => 'Non modèl la';

  @override
  String get formsTemplateNameRequired => 'Tanpri antre non modèl la';

  @override
  String get formsTemplateNameHint => 'Antre non modèl la';

  @override
  String get formsTemplateDescriptionLabel => 'Deskripsyon';

  @override
  String get formsTemplateDescriptionHint => 'Antre deskripsyon modèl la';

  @override
  String get formsSaveSuccess => 'Modèl sove avèk siksè';

  @override
  String formsSaveError(String error) {
    return 'Echwe pou sove modèl la : $error';
  }

  @override
  String get formsDiscardChangesTitle => 'Chanjman pa sove';

  @override
  String get formsDiscardChangesMessage =>
      'Ou gen chanjman ki pa sove. Ou vle revoke yo?';

  @override
  String get formsDiscardButton => 'Revoke';

  @override
  String get formsTabTemplate => 'Modèl';

  @override
  String get formsTabSections => 'Seksyon';

  @override
  String get formsTabPreview => 'Aperçu';
}
