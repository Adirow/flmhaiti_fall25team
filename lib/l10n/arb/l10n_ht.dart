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
  String get patientsCardTitle => 'Pasyan';

  @override
  String get patientsCardSubtitle => 'Jere dosye pasyan yo';

  @override
  String get appointmentsCardTitle => 'Randevou';

  @override
  String get appointmentsCardSubtitle => 'Planifye ak jere';

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
}
