import 'package:flutter/material.dart';

class DateTimeWidget {
  static Future<DateTime?> selectDateTime(context) async {
    DateTime? selectedDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Set the initial date
      firstDate: DateTime(2000), // Set the starting date for the picker
      lastDate: DateTime(2100), // Set the end date for the picker
    );
    if (picked != null && picked != selectedDate) selectedDate = picked;
    return selectedDate;
  }

  static String? dateTimeFormat(String? dateString) {
    String? formattedDate;
    if (dateString != null) {
      DateTime dateTime = DateTime.parse(dateString);
      DateTime pakistanTime = dateTime.toUtc().add(const Duration(hours: 5));
      formattedDate =
          '${pakistanTime.day} ${getMonthName(pakistanTime.month)}, ${pakistanTime.year}';
    }

    return formattedDate;
  }

  static String? timeFormat(String? dateString) {
    int? hour, minute;
    String? period, formattedMinute;

    if (dateString != null) {
      DateTime dateTime = DateTime.parse(dateString);

      // Manually apply the time zone offset for 'Asia/Karachi' (UTC+5)
      DateTime pakistanTime = dateTime.toUtc().add(const Duration(hours: 5));

      hour = pakistanTime.hour;
      minute = pakistanTime.minute;

      period = "AM";
      if (hour >= 12) {
        period = "PM";
        if (hour > 12) hour -= 12;
      }

      if (hour == 0) hour = 12; // Handle midnight as 12 AM

      formattedMinute = minute < 10 ? '0$minute' : minute.toString();
    }

    return hour != null && formattedMinute != null && period != null
        ? '$hour:$formattedMinute $period'
        : "";
  }

  static String getMonthName(int month) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "June",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1]; // Return month name based on the month number
  }

  static int getMonthNumber(String month) {
    int monthNumber = 1;
    switch (month) {
      case "Jan":
        monthNumber = 1;
      case "Feb":
        monthNumber = 2;
      case "Mar":
        monthNumber = 3;
      case "Apr":
        monthNumber = 4;
      case "May":
        monthNumber = 5;
      case "Jun":
        monthNumber = 6;
      case "Jul":
        monthNumber = 7;
      case "Aug":
        monthNumber = 8;
      case "Sep":
        monthNumber = 9;
      case "Oct":
        monthNumber = 10;
      case "Nov":
        monthNumber = 11;
      case "Dec":
        monthNumber = 1;
      default:
        monthNumber = 1;
    }

    return monthNumber;

    // Return month name based on the month number
  }
}
