import 'package:intl/intl.dart';

class CorrencyController {
  String formatCurrency(String amount) {
    final formattedNumber =
        NumberFormat("#,##0", "en_US").format(int.parse(amount));
    return formattedNumber;
  }
}
