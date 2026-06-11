import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/data/models/user.dart';

getFormattedDateFromFormattedString(
    {required value,
    required String currentFormat,
    required String desiredFormat,
    isUtc = true}) {
  DateTime? dateTime;
  if (value != null && value.isNotEmpty) {
    try {
      dateTime = DateFormat(currentFormat).parse(value, isUtc).toLocal();
    } catch (e) {
      print("$e");
    }
  } else {
    dateTime = DateTime.now();
  }
  // print("backtoString: ${dateTime!.toUtc().toIso8601String().runtimeType}");
  return dateTime;
}


double calculateAverageRating(List<Rating> ratingsList) {
  if (ratingsList.isEmpty) return 0.0;

  double totalRating = 0.0;

  for (var item in ratingsList) {
    totalRating += item.rating as double;
  }

  double averageRating = totalRating / ratingsList.length;
  return averageRating;
}


String formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

// // Example Usage
// TimeOfDay selectedTime = TimeOfDay.now();
// String formattedTime = formatTimeOfDay(selectedTime);
// print(formattedTime); // Example Output: "09:00 AM"


TimeOfDay parseTimeOfDay(String timeString) {
  final parts = timeString.split(' ');
  final timeParts = parts[0].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  bool isPM = parts[1] == 'PM';

  if (isPM && hour != 12) {
    hour += 12;
  } else if (!isPM && hour == 12) {
    hour = 0;
  }

  return TimeOfDay(hour: hour, minute: minute);
}

// // Example Usage
// String timeString = "09:00 AM";
// TimeOfDay timeOfDay = parseTimeOfDay(timeString);
// print(timeOfDay); // Output: TimeOfDay(9:00)
