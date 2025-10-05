/// OpenIM error codes
class OpenIMErrorCode {
  // General errors
  static const int success = 0;
  static const int unknown = -1;
  static const int networkError = 10000;
  static const int parameterError = 10001;
  static const int notInitialized = 10002;
  static const int alreadyInitialized = 10003;
  static const int initializationFailed = 10004;
  
  // Authentication errors
  static const int userNotExist = 20000;
  static const int passwordError = 20001;
  static const int tokenExpired = 20002;
  static const int tokenInvalid = 20003;
  static const int userKickedOffline = 20004;
  static const int loginFailed = 20005;
  static const int logoutFailed = 20006;
  
  // Message errors
  static const int messageSendFailed = 30000;
  static const int messageNotExist = 30001;
  static const int messageAlreadyRevoked = 30002;
  static const int messageContentTooLong = 30003;
  
  // Conversation errors
  static const int conversationNotExist = 40000;
  static const int conversationAlreadyExist = 40001;
  
  // Group errors
  static const int groupNotExist = 50000;
  static const int groupMemberNotExist = 50001;
  static const int noPermission = 50002;
  
  // File errors
  static const int fileNotExist = 60000;
  static const int fileUploadFailed = 60001;
  static const int fileDownloadFailed = 60002;
  
  /// Get error message for error code
  static String getErrorMessage(int code) {
    switch (code) {
      case success:
        return 'Success';
      case unknown:
        return 'Unknown error';
      case networkError:
        return 'Network error';
      case parameterError:
        return 'Parameter error';
      case notInitialized:
        return 'SDK not initialized';
      case alreadyInitialized:
        return 'SDK already initialized';
      case initializationFailed:
        return 'SDK initialization failed';
      case userNotExist:
        return 'User does not exist';
      case passwordError:
        return 'Password error';
      case tokenExpired:
        return 'Token expired';
      case tokenInvalid:
        return 'Token invalid';
      case userKickedOffline:
        return 'User kicked offline';
      case loginFailed:
        return 'Login failed';
      case logoutFailed:
        return 'Logout failed';
      case messageSendFailed:
        return 'Message send failed';
      case messageNotExist:
        return 'Message does not exist';
      case messageAlreadyRevoked:
        return 'Message already revoked';
      case messageContentTooLong:
        return 'Message content too long';
      case conversationNotExist:
        return 'Conversation does not exist';
      case conversationAlreadyExist:
        return 'Conversation already exists';
      case groupNotExist:
        return 'Group does not exist';
      case groupMemberNotExist:
        return 'Group member does not exist';
      case noPermission:
        return 'No permission';
      case fileNotExist:
        return 'File does not exist';
      case fileUploadFailed:
        return 'File upload failed';
      case fileDownloadFailed:
        return 'File download failed';
      default:
        return 'Unknown error ($code)';
    }
  }
}