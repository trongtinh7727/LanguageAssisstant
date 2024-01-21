import 'package:intl/intl.dart';

class DateTimeUtil {
  static DateTime timestampToDateTime(int timestamp) {
    // Dart's DateTime uses milliseconds since epoch, so multiply by 1000
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  }

  static String getDateFromTimestamp(int timestamp) {
    DateTime timestampDateTime = timestampToDateTime(timestamp);
    DateTime now = DateTime.now().toUtc();

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
}
