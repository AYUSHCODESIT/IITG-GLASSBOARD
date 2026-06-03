import 'firebase_service.dart';

class AuditLogger {
  static Future<void> logLogin(String device) async {
    await FirebaseService().writeAuditLog('LOGIN', null, {'device': device});
  }

  static Future<void> logLogout() async {
    await FirebaseService().writeAuditLog('LOGOUT', null, {});
  }

  static Future<void> logTaskCreate(String moduleId, String taskTitle) async {
    await FirebaseService().writeAuditLog('TASK_CREATE', moduleId, {'taskTitle': taskTitle});
  }

  static Future<void> logTaskUpdate(String moduleId, String taskTitle, double progress) async {
    await FirebaseService().writeAuditLog('TASK_UPDATE', moduleId, {
      'taskTitle': taskTitle,
      'newProgress': progress,
    });
  }

  static Future<void> logHandshakeCreate(String senderModuleId, String receiverModuleName) async {
    await FirebaseService().writeAuditLog('HANDSHAKE_CREATE', senderModuleId, {
      'targetModule': receiverModuleName,
    });
  }

  static Future<void> logHandshakeAccept(String receiverModuleId, String senderModuleName) async {
    await FirebaseService().writeAuditLog('HANDSHAKE_ACCEPT', receiverModuleId, {
      'sourceModule': senderModuleName,
    });
  }

  static Future<void> logHandshakeReject(String receiverModuleId, String senderModuleName, String reason) async {
    await FirebaseService().writeAuditLog('HANDSHAKE_REJECT', receiverModuleId, {
      'sourceModule': senderModuleName,
      'reason': reason,
    });
  }

  static Future<void> logFileUpload(String moduleId, String fileName, int version) async {
    await FirebaseService().writeAuditLog('FILE_UPLOAD', moduleId, {
      'fileName': fileName,
      'version': version,
    });
  }

  static Future<void> logFileModification(String moduleId, String fileName, int version, String changeSummary) async {
    await FirebaseService().writeAuditLog('FILE_MODIFY', moduleId, {
      'fileName': fileName,
      'version': version,
      'summary': changeSummary,
    });
  }
}
