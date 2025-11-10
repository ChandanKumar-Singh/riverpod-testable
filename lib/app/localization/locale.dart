// FEATURE: Localization
import 'package:flutter/material.dart';

import 'package:testable/l10n/app_localizations.dart';
import 'package:testable/l10n/app_localizations_en.dart';

extension AppLocalizationsExt on BuildContext {
  AppLocalizations get lang =>
      AppLocalizations.of(this) ?? AppLocalizationsEn();
}
