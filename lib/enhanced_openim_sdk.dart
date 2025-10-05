library enhanced_openim_sdk;

/// Enhanced OpenIM SDK for Flutter
/// 
/// This is a modernized, developer-friendly wrapper around the OpenIM SDK
/// that provides:
/// - Type-safe APIs with proper error handling
/// - Future/Stream-based async operations instead of callbacks
/// - Simplified initialization process
/// - Better event system with strongly-typed events
/// - Intuitive API design following Flutter conventions
/// 
/// Example usage:
/// ```dart
/// import 'package:enhanced_openim_sdk/enhanced_openim_sdk.dart';
/// 
/// // Initialize SDK
/// await OpenIMClient.instance.initialize(
///   config: OpenIMConfig(
///     apiUrl: 'https://your-server.com',
///     wsUrl: 'wss://your-server.com',
///   ),
/// );
/// 
/// // Login
/// final userInfo = await OpenIMClient.instance.login(
///   userID: 'user123',
///   token: 'your-auth-token',
/// );
/// 
/// // Send message
/// final message = await MessageBuilder.createTextMessage(text: 'Hello!');
/// await OpenIMClient.instance.message.sendMessage(
///   message: message,
///   userID: 'friend_user_id',
/// );
/// 
/// // Listen to events
/// OpenIMClient.instance.events.listen((event) {
///   if (event is NewMessageEvent) {
///     print('New message: ${event.message.content}');
///   }
/// });
/// ```

// Core components
export 'core/openim_client.dart';
export 'core/connection_manager.dart';
export 'core/message_manager.dart';
export 'core/conversation_manager.dart';
export 'core/user_manager.dart';

// Models
export 'models/models.dart';

// Events
export 'events/events.dart';

// Errors
export 'errors/errors.dart';