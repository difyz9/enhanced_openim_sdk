import 'dart:async';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../events/events.dart';
import '../errors/errors.dart';

/// Enhanced user manager for user-related operations
class UserManager {
  final MethodChannel _channel;
  final StreamController<OpenIMEvent> _eventController;
  
  UserManager(this._channel, this._eventController);
  
  /// Get user information by user ID
  /// 
  /// Example:
  /// ```dart
  /// final userInfo = await userManager.getUserInfo(userID: 'user123');
  /// ```
  Future<UserInfo> getUserInfo({
    required String userID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getUsersInfo', {
        'userIDList': [userID],
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> userList = result['data'] ?? [];
        if (userList.isNotEmpty) {
          return UserInfo.fromJson(userList.first);
        } else {
          throw OpenIMException(
            code: OpenIMErrorCode.userNotExist,
            message: 'User not found',
          );
        }
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get user info',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get user info: $e',
      );
    }
  }
  
  /// Get multiple users information
  Future<List<UserInfo>> getUsersInfo({
    required List<String> userIDs,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getUsersInfo', {
        'userIDList': userIDs,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> userList = result['data'] ?? [];
        return userList.map((json) => UserInfo.fromJson(json)).toList();
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get users info',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get users info: $e',
      );
    }
  }
  
  /// Update current user's profile
  Future<void> updateUserInfo({
    String? nickname,
    String? faceURL,
    String? ex,
    String? operationID,
  }) async {
    final Map<String, dynamic> userInfo = {};
    if (nickname != null) userInfo['nickname'] = nickname;
    if (faceURL != null) userInfo['faceURL'] = faceURL;
    if (ex != null) userInfo['ex'] = ex;
    
    if (userInfo.isEmpty) {
      throw OpenIMException(
        code: OpenIMErrorCode.parameterError,
        message: 'At least one field must be provided for update',
      );
    }
    
    try {
      final result = await _channel.invokeMethod('setSelfInfo', {
        'userInfo': userInfo,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to update user info',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to update user info: $e',
      );
    }
  }
  
  /// Get current user's self info
  Future<UserInfo> getSelfInfo({String? operationID}) async {
    try {
      final result = await _channel.invokeMethod('getSelfUserInfo', {
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        return UserInfo.fromJson(result['data']);
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get self info',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get self info: $e',
      );
    }
  }
  
  /// Search users
  Future<List<UserInfo>> searchUsers({
    required String keyword,
    int offset = 0,
    int count = 20,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('searchUsers', {
        'keyword': keyword,
        'offset': offset,
        'count': count,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> userList = result['data']['users'] ?? [];
        return userList.map((json) => UserInfo.fromJson(json)).toList();
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to search users',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to search users: $e',
      );
    }
  }
  
  /// Set global receive message option
  /// 0: receive normally, 1: do not receive, 2: receive but no notification
  Future<void> setGlobalRecvMessageOpt({
    required int opt,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('setGlobalRecvMessageOpt', {
        'opt': opt,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to set global receive message option',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to set global receive message option: $e',
      );
    }
  }
  
  /// Subscribe to user online status
  Future<void> subscribeUsersStatus({
    required List<String> userIDs,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('subscribeUsersStatus', {
        'userIDList': userIDs,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to subscribe users status',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to subscribe users status: $e',
      );
    }
  }
  
  /// Unsubscribe from user online status
  Future<void> unsubscribeUsersStatus({
    required List<String> userIDs,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('unsubscribeUsersStatus', {
        'userIDList': userIDs,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to unsubscribe users status',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to unsubscribe users status: $e',
      );
    }
  }
  
  /// Get subscribed users status
  Future<List<Map<String, dynamic>>> getSubscribedUsersStatus({
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getSubscribeUsersStatus', {
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> statusList = result['data'] ?? [];
        return statusList.cast<Map<String, dynamic>>();
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get subscribed users status',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get subscribed users status: $e',
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