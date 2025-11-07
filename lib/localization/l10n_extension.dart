import 'package:flutter/widgets.dart';
import 'package:flmhaiti_fall25team/l10n/l10n.dart';

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
