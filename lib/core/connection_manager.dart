import 'dart:async';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../events/events.dart';
import '../errors/errors.dart';

/// Connection manager handles authentication and connection state
class ConnectionManager {
  final MethodChannel _channel;
  final StreamController<OpenIMEvent> _eventController;
  
  LoginStatus _loginStatus = LoginStatus.logout;
  UserInfo? _currentUser;
  
  ConnectionManager(this._channel, this._eventController);
  
  /// Current login status
  LoginStatus get loginStatus => _loginStatus;
  
  /// Current logged in user information
  UserInfo? get currentUser => _currentUser;
  
  /// Login with user credentials
  /// 
  /// Example:
  /// ```dart
  /// final userInfo = await connectionManager.login(
  ///   userID: 'user123',
  ///   token: 'your-auth-token',
  /// );
  /// ```
  Future<UserInfo> login({
    required String userID,
    required String token,
  }) async {
    try {
      _loginStatus = LoginStatus.logging;
      _eventController.add(UserLoginEvent(userID));
      
      final result = await _channel.invokeMethod('login', {
        'userID': userID,
        'token': token,
        'operationID': _generateOperationID(),
      });
      
      if (result['success'] == true) {
        _currentUser = UserInfo.fromJson(result['data']);
        _loginStatus = LoginStatus.success;
        return _currentUser!;
      } else {
        _loginStatus = LoginStatus.failed;
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.loginFailed,
          message: result['errMsg'] ?? 'Login failed',
        );
      }
    } catch (e) {
      _loginStatus = LoginStatus.failed;
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.loginFailed,
        message: 'Login failed: $e',
      );
    }
  }
  
  /// Logout current user
  Future<void> logout() async {
    try {
      final result = await _channel.invokeMethod('logout', {
        'operationID': _generateOperationID(),
      });
      
      if (result['success'] == true) {
        _currentUser = null;
        _loginStatus = LoginStatus.logout;
        _eventController.add(UserLogoutEvent());
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.logoutFailed,
          message: result['errMsg'] ?? 'Logout failed',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.logoutFailed,
        message: 'Logout failed: $e',
      );
    }
  }
  
  /// Get current user's login status from native SDK
  Future<LoginStatus> getLoginStatus() async {
    try {
      final result = await _channel.invokeMethod('getLoginStatus', {
        'operationID': _generateOperationID(),
      });
      
      final status = LoginStatus.fromValue(result['data'] ?? 1);
      _loginStatus = status;
      return status;
    } catch (e) {
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get login status: $e',
      );
    }
  }
  
  /// Update FCM token for push notifications (Android)
  Future<void> updateFCMToken(String token) async {
    try {
      await _channel.invokeMethod('updateFCMToken', {
        'fcmToken': token,
        'expireTime': DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch,
        'operationID': _generateOperationID(),
      });
    } catch (e) {
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to update FCM token: $e',
      );
    }
  }
  
  /// Force sync data from server
  Future<void> forceSyncData() async {
    try {
      await _channel.invokeMethod('forceSyncData', {
        'operationID': _generateOperationID(),
      });
    } catch (e) {
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to sync data: $e',
      );
    }
  }
  
  /// Upload logs to server for debugging
  Future<void> uploadLogs() async {
    try {
      await _channel.invokeMethod('uploadLogs', {
        'operationID': _generateOperationID(),
      });
    } catch (e) {
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to upload logs: $e',
      );
    }
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    // Clean up any resources if needed
  }
  
  String _generateOperationID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}