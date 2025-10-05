/// Enhanced OpenIM SDK Core Client
/// 
/// This is a modernized, developer-friendly wrapper around the OpenIM SDK
/// that provides:
/// - Type-safe APIs
/// - Future/Stream-based async operations
/// - Simplified initialization
/// - Better error handling
/// - Intuitive event system

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/models.dart';
import '../events/events.dart';
import '../errors/errors.dart';
import 'connection_manager.dart';
import 'message_manager.dart';
import 'conversation_manager.dart';
import 'user_manager.dart';

/// Main OpenIM client providing access to all SDK functionality
class OpenIMClient {
  static OpenIMClient? _instance;
  static const MethodChannel _channel = MethodChannel('enhanced_openim_sdk');
  
  late ConnectionManager _connectionManager;
  late MessageManager _messageManager;
  late ConversationManager _conversationManager;
  late UserManager _userManager;
  
  final StreamController<OpenIMEvent> _eventController = StreamController.broadcast();
  
  bool _isInitialized = false;
  
  OpenIMClient._internal();
  
  /// Get the singleton instance of OpenIMClient
  static OpenIMClient get instance {
    _instance ??= OpenIMClient._internal();
    return _instance!;
  }
  
  /// Initialize the OpenIM SDK with configuration
  /// 
  /// Example:
  /// ```dart
  /// await OpenIMClient.instance.initialize(
  ///   config: OpenIMConfig(
  ///     apiUrl: 'https://your-server.com',
  ///     wsUrl: 'wss://your-server.com',
  ///     platform: Platform.android,
  ///   ),
  /// );
  /// ```
  Future<void> initialize({
    required OpenIMConfig config,
  }) async {
    if (_isInitialized) {
      throw OpenIMException(
        code: OpenIMErrorCode.alreadyInitialized,
        message: 'OpenIM SDK is already initialized',
      );
    }
    
    try {
      // Initialize platform channel
      _channel.setMethodCallHandler(_handleMethodCall);
      
      // Initialize managers
      _connectionManager = ConnectionManager(_channel, _eventController);
      _messageManager = MessageManager(_channel, _eventController);
      _conversationManager = ConversationManager(_channel, _eventController);
      _userManager = UserManager(_channel, _eventController);
      
      // Initialize native SDK
      final result = await _channel.invokeMethod('initialize', config.toJson());
      
      if (result['success'] != true) {
        throw OpenIMException(
          code: OpenIMErrorCode.initializationFailed,
          message: result['message'] ?? 'Failed to initialize SDK',
        );
      }
      
      _isInitialized = true;
      
      // Emit initialization event
      _eventController.add(SDKInitializedEvent());
      
    } catch (e) {
      if (e is OpenIMException) rethrow;
      throw OpenIMException(
        code: OpenIMErrorCode.initializationFailed,
        message: 'Failed to initialize OpenIM SDK: $e',
      );
    }
  }
  
  /// Login with user credentials
  /// 
  /// Example:
  /// ```dart
  /// final userInfo = await OpenIMClient.instance.login(
  ///   userID: 'user123',
  ///   token: 'your-auth-token',
  /// );
  /// ```
  Future<UserInfo> login({
    required String userID,
    required String token,
  }) async {
    _ensureInitialized();
    return await _connectionManager.login(userID: userID, token: token);
  }
  
  /// Logout current user
  Future<void> logout() async {
    _ensureInitialized();
    return await _connectionManager.logout();
  }
  
  /// Get current login status
  LoginStatus get loginStatus {
    _ensureInitialized();
    return _connectionManager.loginStatus;
  }
  
  /// Stream of all OpenIM events
  Stream<OpenIMEvent> get events => _eventController.stream;
  
  /// Connection manager for connection-related operations
  ConnectionManager get connection {
    _ensureInitialized();
    return _connectionManager;
  }
  
  /// Message manager for message-related operations
  MessageManager get message {
    _ensureInitialized();
    return _messageManager;
  }
  
  /// Conversation manager for conversation-related operations
  ConversationManager get conversation {
    _ensureInitialized();
    return _conversationManager;
  }
  
  /// User manager for user-related operations
  UserManager get user {
    _ensureInitialized();
    return _userManager;
  }
  
  /// Dispose resources and cleanup
  Future<void> dispose() async {
    if (!_isInitialized) return;
    
    await _connectionManager.dispose();
    await _messageManager.dispose();
    await _conversationManager.dispose();
    await _userManager.dispose();
    
    await _eventController.close();
    
    _isInitialized = false;
    _instance = null;
  }
  
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw OpenIMException(
        code: OpenIMErrorCode.notInitialized,
        message: 'OpenIM SDK is not initialized. Call initialize() first.',
      );
    }
  }
  
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    try {
      // Handle platform events and convert them to OpenIM events
      switch (call.method) {
        case 'onConnectionStateChanged':
          final state = ConnectionState.fromJson(call.arguments);
          _eventController.add(ConnectionStateChangedEvent(state));
          break;
          
        case 'onNewMessage':
          final message = Message.fromJson(call.arguments);
          _eventController.add(NewMessageEvent(message));
          break;
          
        case 'onConversationChanged':
          final conversations = (call.arguments as List)
              .map((e) => Conversation.fromJson(e))
              .toList();
          _eventController.add(ConversationsChangedEvent(conversations));
          break;
          
        default:
          debugPrint('Unhandled method call: ${call.method}');
      }
    } catch (e) {
      debugPrint('Error handling method call ${call.method}: $e');
    }
    
    return null;
  }
}