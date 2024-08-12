extension DateTimeParser on String {
  /// Formats date string to look like `11th of July 2023`
  String toDDofMMYYYY() {
    final dateTime = _parseDateString();

    final day = _getDayWithSuffix(dateTime.day);
    final month = _getMonthName(dateTime.month);
    final year = dateTime.year.toString();

    return '$day of $month $year';
  }

  String toDDMMYYYY() {
    final inputDateParts = split(' ')[0].split('-');
    final day = inputDateParts[2];
    final month = inputDateParts[1];
    final year = inputDateParts[0];
    return '$day-$month-$year';
  }

  String toMMDD() {
    final dateTime = _parseDateString();

    final day = dateTime.day;
    final month = _getMonthName(dateTime.month);

    return '${month.toUpperCase()} $day';
  }

  String toHHMM() {
    var time = DateTime.parse(this);
    int hour = time.hour;
    String minute = time.minute.toString().padRight(2, '0');
    return '$hour:$minute';
  }

  DateTime _parseDateString() {
    final dateParts = split(' ')[0].split('-');

    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    return DateTime.utc(year, month, day);
  }

  String _getDayWithSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return '${day}th';
    }
    switch (day % 10) {
      // Use modulus operator (%) here
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  String _getMonthName(int month) {
    final months = <String>[
      '', // Index 0 is unused for month names
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    return months[month];
  }
}

extension DateFormatExtension on String {
  String convertToCustomDateFormat() {
    try {
      final dateTime = DateTime.parse(this);
      final day = dateTime.day;
      final month = dateTime.month;
      final year = dateTime.year;

      // Define a list of month names
      final List<String> monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];

      // Convert the day to the format "22nd"
      String dayString;
      if (day >= 11 && day <= 13) {
        dayString = '$day' 'th';
      } else {
        switch (day % 10) {
          case 1:
            dayString = '$day' 'st';
            break;
          case 2:
            dayString = '$day' 'nd';
            break;
          case 3:
            dayString = '$day' 'rd';
            break;
          default:
            dayString = '$day' 'th';
            break;
        }
      }

      // Build the formatted date string
      final formattedDate = '$dayString of ${monthNames[month - 1]} $year';

      return formattedDate;
    } catch (e) {
      throw Exception("Invalid date format");
    }
  }
}
