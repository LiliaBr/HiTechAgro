import 'package:intl/intl.dart';

extension DateTimeFormatted on DateTime { 
	static final DateFormat _dateFormatter = DateFormat('dd.MM.yyyy HH:mm', 'ru_RU');
	static final DateFormat _dateFormatterNoTime = DateFormat('dd.MM.yyyy', 'ru_RU');

  String format({bool noTime = false}) {

		return noTime 
						? _dateFormatterNoTime.format(this.toLocal())
						: _dateFormatter.format(this.toLocal());
  }
}