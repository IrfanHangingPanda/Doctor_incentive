import 'package:doctors_incentive/language/english.dart';
import 'package:get/get.dart';

class ChangeLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': English.englishLanguage,
      };
}
