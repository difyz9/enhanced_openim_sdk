import 'error_codes.dart';

/// Enhanced OpenIM SDK exception
class OpenIMException implements Exception {
  final int code;
  final String message;
  final dynamic details;
  final StackTrace? stackTrace;
  
  const OpenIMException({
    required this.code,
    required this.message,
    this.details,
    this.stackTrace,
  });
  
  /// Create exception from error code
  factory OpenIMException.fromCode(int code, {dynamic details, StackTrace? stackTrace}) {
    return OpenIMException(
      code: code,
      message: OpenIMErrorCode.getErrorMessage(code),
      details: details,
      stackTrace: stackTrace,
    );
  }
  
  /// Create exception from platform error
  factory OpenIMException.fromPlatformError(Map<String, dynamic> error) {
    return OpenIMException(
      code: error['code'] ?? OpenIMErrorCode.unknown,
      message: error['message'] ?? 'Unknown error',
      details: error['details'],
    );
  }
  
  /// Check if this is a network error
  bool get isNetworkError => code == OpenIMErrorCode.networkError;
  
  /// Check if this is an authentication error
  bool get isAuthError => code >= 20000 && code < 30000;
  
  /// Check if this is a message error
  bool get isMessageError => code >= 30000 && code < 40000;
  
  /// Check if this is a conversation error
  bool get isConversationError => code >= 40000 && code < 50000;
  
  /// Check if this is a group error
  bool get isGroupError => code >= 50000 && code < 60000;
  
  /// Check if this is a file error
  bool get isFileError => code >= 60000 && code < 70000;
  
  @override
  String toString() {
    final buffer = StringBuffer('OpenIMException: $message (code: $code)');
    if (details != null) {
      buffer.write('\nDetails: $details');
    }
    if (stackTrace != null) {
      buffer.write('\nStack trace:\n$stackTrace');
    }
    return buffer.toString();
  }
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenIMException &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message;
  
  @override
  int get hashCode => code.hashCode ^ message.hashCode;
}