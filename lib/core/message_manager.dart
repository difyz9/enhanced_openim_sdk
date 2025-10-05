import 'dart:async';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../events/events.dart';
import '../errors/errors.dart';

/// Message creation utilities
class MessageBuilder {
  /// Create a text message
  static Future<Message> createTextMessage({
    required String text,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createTextMessage', {
      'text': text,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create an image message
  static Future<Message> createImageMessage({
    required String imagePath,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createImageMessage', {
      'imagePath': imagePath,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create an audio message
  static Future<Message> createAudioMessage({
    required String audioPath,
    required int duration,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createAudioMessage', {
      'audioPath': audioPath,
      'duration': duration,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create a video message
  static Future<Message> createVideoMessage({
    required String videoPath,
    required String videoType,
    required int duration,
    required String snapshotPath,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createVideoMessage', {
      'videoPath': videoPath,
      'videoType': videoType,
      'duration': duration,
      'snapshotPath': snapshotPath,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create a file message
  static Future<Message> createFileMessage({
    required String filePath,
    required String fileName,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createFileMessage', {
      'filePath': filePath,
      'fileName': fileName,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create a location message
  static Future<Message> createLocationMessage({
    required double latitude,
    required double longitude,
    required String description,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createLocationMessage', {
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
  
  /// Create a custom message
  static Future<Message> createCustomMessage({
    required String data,
    required String extension,
    required String description,
    String? operationID,
  }) async {
    const channel = MethodChannel('enhanced_openim_sdk');
    final result = await channel.invokeMethod('createCustomMessage', {
      'data': data,
      'extension': extension,
      'description': description,
      'operationID': operationID ?? DateTime.now().millisecondsSinceEpoch.toString(),
    });
    return Message.fromJson(result);
  }
}

/// Enhanced message manager with modern API design
class MessageManager {
  final MethodChannel _channel;
  final StreamController<OpenIMEvent> _eventController;
  
  // Stream controllers for different message events
  final StreamController<Message> _newMessageController = StreamController.broadcast();
  final StreamController<MessageSendProgressEvent> _sendProgressController = StreamController.broadcast();
  
  MessageManager(this._channel, this._eventController);
  
  /// Stream of new messages
  Stream<Message> get newMessages => _newMessageController.stream;
  
  /// Stream of message send progress
  Stream<MessageSendProgressEvent> get sendProgress => _sendProgressController.stream;
  
  /// Send a message to a user
  /// 
  /// Example:
  /// ```dart
  /// final message = await MessageBuilder.createTextMessage(text: 'Hello!');
  /// await messageManager.sendMessage(
  ///   message: message,
  ///   userID: 'user123',
  /// );
  /// ```
  Future<Message> sendMessage({
    required Message message,
    String? userID,
    String? groupID,
    String? operationID,
  }) async {
    if (userID == null && groupID == null) {
      throw OpenIMException(
        code: OpenIMErrorCode.parameterError,
        message: 'Either userID or groupID must be provided',
      );
    }
    
    try {
      final result = await _channel.invokeMethod('sendMessage', {
        'message': message.toJson(),
        'userID': userID,
        'groupID': groupID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final sentMessage = Message.fromJson(result['data']);
        _eventController.add(MessageSentEvent(sentMessage));
        return sentMessage;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.messageSendFailed,
          message: result['errMsg'] ?? 'Failed to send message',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.messageSendFailed,
        message: 'Failed to send message: $e',
      );
    }
  }
  
  /// Get conversation message history
  /// 
  /// Example:
  /// ```dart
  /// final messages = await messageManager.getHistoryMessages(
  ///   conversationID: 'conv123',
  ///   count: 20,
  /// );
  /// ```
  Future<List<Message>> getHistoryMessages({
    required String conversationID,
    Message? startMessage,
    int count = 20,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getHistoryMessageList', {
        'conversationID': conversationID,
        'startMsg': startMessage?.toJson(),
        'count': count,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> messageList = result['data']['messageList'] ?? [];
        return messageList.map((json) => Message.fromJson(json)).toList();
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get messages',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get history messages: $e',
      );
    }
  }
  
  /// Revoke a message
  Future<void> revokeMessage({
    required String conversationID,
    required String clientMsgID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('revokeMessage', {
        'conversationID': conversationID,
        'clientMsgID': clientMsgID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to revoke message',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to revoke message: $e',
      );
    }
  }
  
  /// Delete a message
  Future<void> deleteMessage({
    required String conversationID,
    required String clientMsgID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('deleteMessage', {
        'conversationID': conversationID,
        'clientMsgID': clientMsgID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to delete message',
        );
      }
      
      _eventController.add(MessageDeletedEvent(clientMsgID));
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to delete message: $e',
      );
    }
  }
  
  /// Mark messages as read
  Future<void> markMessagesAsRead({
    required String conversationID,
    required List<String> clientMsgIDs,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('markMessagesAsRead', {
        'conversationID': conversationID,
        'clientMsgIDs': clientMsgIDs,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to mark messages as read',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to mark messages as read: $e',
      );
    }
  }
  
  /// Search for messages
  Future<List<Message>> searchMessages({
    required String conversationID,
    String? keyword,
    List<MessageType>? messageTypes,
    int? startTime,
    int? endTime,
    int offset = 0,
    int count = 20,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('searchLocalMessages', {
        'conversationID': conversationID,
        'keywordList': keyword != null ? [keyword] : [],
        'messageTypeList': messageTypes?.map((t) => t.value).toList() ?? [],
        'startTime': startTime,
        'endTime': endTime,
        'offset': offset,
        'count': count,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> messageList = result['data']['searchResultItems'] ?? [];
        return messageList
            .expand((item) => (item['messageList'] as List? ?? []))
            .map((json) => Message.fromJson(json))
            .toList();
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to search messages',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to search messages: $e',
      );
    }
  }
  
  /// Upload file and get URL
  Future<String> uploadFile({
    required String filePath,
    required String fileName,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('uploadFile', {
        'filePath': filePath,
        'fileName': fileName,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        return result['data']['url'] ?? '';
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.fileUploadFailed,
          message: result['errMsg'] ?? 'Failed to upload file',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.fileUploadFailed,
        message: 'Failed to upload file: $e',
      );
    }
  }
  
  /// Handle new message from platform
  void handleNewMessage(Message message) {
    _newMessageController.add(message);
    _eventController.add(NewMessageEvent(message));
  }
  
  /// Handle message send progress
  void handleSendProgress(String clientMsgID, int progress) {
    final event = MessageSendProgressEvent(
      clientMsgID: clientMsgID,
      progress: progress,
    );
    _sendProgressController.add(event);
    _eventController.add(event);
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await _newMessageController.close();
    await _sendProgressController.close();
  }
  
  String _generateOperationID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}