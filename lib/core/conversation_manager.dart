import 'dart:async';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../events/events.dart';
import '../errors/errors.dart';

/// Enhanced conversation manager with modern API design
class ConversationManager {
  final MethodChannel _channel;
  final StreamController<OpenIMEvent> _eventController;
  
  // Stream controllers for conversation events
  final StreamController<List<Conversation>> _conversationsController = StreamController.broadcast();
  final StreamController<Conversation> _conversationChangedController = StreamController.broadcast();
  
  ConversationManager(this._channel, this._eventController);
  
  /// Stream of all conversations
  Stream<List<Conversation>> get conversations => _conversationsController.stream;
  
  /// Stream of individual conversation changes
  Stream<Conversation> get conversationChanges => _conversationChangedController.stream;
  
  /// Get all conversations
  /// 
  /// Example:
  /// ```dart
  /// final conversations = await conversationManager.getAllConversations();
  /// ```
  Future<List<Conversation>> getAllConversations({
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getAllConversationList', {
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final List<dynamic> conversationList = result['data'] ?? [];
        final conversations = conversationList
            .map((json) => Conversation.fromJson(json))
            .toList();
        
        _conversationsController.add(conversations);
        return conversations;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get conversations',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get conversations: $e',
      );
    }
  }
  
  /// Get conversation by ID
  Future<Conversation?> getConversation({
    required String conversationID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('getOneConversation', {
        'conversationID': conversationID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        return Conversation.fromJson(result['data']);
      } else if (result['errCode'] == OpenIMErrorCode.conversationNotExist) {
        return null;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get conversation',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get conversation: $e',
      );
    }
  }
  
  /// Get or create conversation for single chat
  Future<Conversation> getOrCreateSingleConversation({
    required String userID,
    String? operationID,
  }) async {
    try {
      final conversationID = 'single_$userID';
      final existing = await getConversation(conversationID: conversationID);
      
      if (existing != null) {
        return existing;
      }
      
      // Create new conversation if not exists
      final result = await _channel.invokeMethod('createSingleConversation', {
        'userID': userID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final conversation = Conversation.fromJson(result['data']);
        _eventController.add(NewConversationEvent(conversation));
        return conversation;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to create conversation',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get or create conversation: $e',
      );
    }
  }
  
  /// Get or create conversation for group chat
  Future<Conversation> getOrCreateGroupConversation({
    required String groupID,
    String? operationID,
  }) async {
    try {
      final conversationID = 'group_$groupID';
      final existing = await getConversation(conversationID: conversationID);
      
      if (existing != null) {
        return existing;
      }
      
      // Create new group conversation if not exists
      final result = await _channel.invokeMethod('createGroupConversation', {
        'groupID': groupID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        final conversation = Conversation.fromJson(result['data']);
        _eventController.add(NewConversationEvent(conversation));
        return conversation;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to create group conversation',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get or create group conversation: $e',
      );
    }
  }
  
  /// Delete conversation
  Future<void> deleteConversation({
    required String conversationID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('deleteConversation', {
        'conversationID': conversationID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to delete conversation',
        );
      }
      
      _eventController.add(ConversationDeletedEvent(conversationID));
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to delete conversation: $e',
      );
    }
  }
  
  /// Pin or unpin conversation
  Future<void> pinConversation({
    required String conversationID,
    required bool isPinned,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('pinConversation', {
        'conversationID': conversationID,
        'isPinned': isPinned,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to pin conversation',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to pin conversation: $e',
      );
    }
  }
  
  /// Set conversation draft
  Future<void> setConversationDraft({
    required String conversationID,
    required String draftText,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('setConversationDraft', {
        'conversationID': conversationID,
        'draftText': draftText,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to set conversation draft',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to set conversation draft: $e',
      );
    }
  }
  
  /// Mark conversation as read
  Future<void> markConversationAsRead({
    required String conversationID,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('markConversationMessageAsRead', {
        'conversationID': conversationID,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to mark conversation as read',
        );
      }
      
      _eventController.add(ConversationReadEvent(
        conversationID: conversationID,
        readCount: 0, // Reset unread count
      ));
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to mark conversation as read: $e',
      );
    }
  }
  
  /// Get total unread message count
  Future<int> getTotalUnreadCount({String? operationID}) async {
    try {
      final result = await _channel.invokeMethod('getTotalUnreadMsgCount', {
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] == true) {
        return result['data'] ?? 0;
      } else {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to get unread count',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to get total unread count: $e',
      );
    }
  }
  
  /// Set conversation receive message option
  /// 0: receive normally, 1: do not receive, 2: receive but no notification
  Future<void> setConversationRecvMessageOpt({
    required String conversationID,
    required int opt,
    String? operationID,
  }) async {
    try {
      final result = await _channel.invokeMethod('setConversationRecvMessageOpt', {
        'conversationID': conversationID,
        'opt': opt,
        'operationID': operationID ?? _generateOperationID(),
      });
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: result['errCode'] ?? OpenIMErrorCode.unknown,
          message: result['errMsg'] ?? 'Failed to set receive message option',
        );
      }
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.unknown,
        message: 'Failed to set receive message option: $e',
      );
    }
  }
  
  /// Handle conversation changes from platform
  void handleConversationsChanged(List<Conversation> conversations) {
    _conversationsController.add(conversations);
    _eventController.add(ConversationsChangedEvent(conversations));
  }
  
  /// Handle single conversation change
  void handleConversationChanged(Conversation conversation) {
    _conversationChangedController.add(conversation);
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await _conversationsController.close();
    await _conversationChangedController.close();
  }
  
  String _generateOperationID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}