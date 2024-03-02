import 'package:intl/intl.dart';

class DateTimeUtil {
  static final int _offset = 7 * 3600 * 1000;
  static DateTime timestampToDateTime(int timestamp) {
    // Dart's DateTime uses milliseconds since epoch, so multiply by 1000
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
        .add(Duration(milliseconds: _offset));
  }

  static int getCurrentTimestamp() {
    return DateTime.now()
            .toUtc()
            .add(Duration(milliseconds: _offset))
            .millisecondsSinceEpoch ~/
        1000; // chia cho 1000 để chuyển từ mili giây sang giây
  }

  static String getDateFromTimestamp(int timestamp) {
    DateTime timestampDateTime = timestampToDateTime(timestamp);
    DateTime now = DateTime.now().toUtc().add(Duration(milliseconds: _offset));

    Duration difference = now.difference(timestampDateTime);

    if (difference.inSeconds < 60) {
      return "Vừa tức thì";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} phút trước";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} giờ trước";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} ngày trước";
    } else {
      // For weeks and months, we calculate them manually
      int weeksAgo = (difference.inDays / 7).floor();
      int monthsAgo = (difference.inDays / 30).floor(); // Approximate

      if (weeksAgo < 5) {
        return "$weeksAgo tuần trước";
      } else if (monthsAgo < 12) {
        return "$monthsAgo tháng trước";
      } else {
        return DateFormat('dd/MM/yyyy').format(timestampDateTime);
      }
    }
  }

  static String format(int timestamp) {
    DateTime time = timestampToDateTime(timestamp);
    String formattedDate =
        "${time.hour}:${time.minute} ${time.day} tháng ${time.month}, ${time.year}";
    return formattedDate;
  }

  static String formatTimeDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    StringBuffer timeStringBuilder = StringBuffer();

    if (hours > 0) {
      timeStringBuilder.write('${hours}h');
    }

    if (minutes > 0 || hours > 0) {
      timeStringBuilder.write('${minutes}p');
    }

    timeStringBuilder.write('${remainingSeconds}');

    return timeStringBuilder.toString();
  }
}
