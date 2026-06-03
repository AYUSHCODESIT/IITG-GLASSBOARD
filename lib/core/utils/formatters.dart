import 'package:intl/intl.dart' if (dart.library.html) 'package:intl/intl.dart'; // Safe fallback
import 'package:timeago/timeago.dart' as timeago;

class Formatters {
  static String formatPercent(double value) {
    return '${value.toStringAsFixed(0)}%';
  }

  static String formatDate(DateTime dateTime) {
    // Return standard MM/dd/yyyy format
    return '${dateTime.month.toString().padLeft(2, '0')}/${dateTime.day.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  static String formatRelative(DateTime dateTime) {
    return timeago.format(dateTime);
  }

  static String getPriorityString(String priority) {
    if (priority.isEmpty) return 'Normal';
    return priority[0].toUpperCase() + priority.substring(1).toLowerCase();
  }

  static String formatRole(String role) {
    switch (role) {
      case 'employee':
        return 'Employee';
      case 'lead':
        return 'Module Lead';
      case 'org_head':
        return 'Organization Head';
      case 'admin':
        return 'Administrator';
      default:
        return 'Member';
    }
  }

  static String formatStatus(String status) {
    switch (status) {
      case 'not_started':
        return 'Not Started';
      case 'in_progress':
        return 'In Progress';
      case 'blocked':
        return 'Blocked';
      case 'completed':
        return 'Completed';
      default:
        return 'Unknown';
    }
  }
}
