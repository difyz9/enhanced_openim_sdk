import 'base_event.dart';
import '../models/conversation.dart';

/// Conversations changed event
class ConversationsChangedEvent extends OpenIMEvent {
  final List<Conversation> conversations;
  
  ConversationsChangedEvent(this.conversations);
  
  @override
  String toString() => 'ConversationsChangedEvent(conversations: ${conversations.length})';
}

/// New conversation added event
class NewConversationEvent extends OpenIMEvent {
  final Conversation conversation;
  
  NewConversationEvent(this.conversation);
  
  @override
  String toString() => 'NewConversationEvent(conversation: $conversation)';
}

/// Conversation deleted event
class ConversationDeletedEvent extends OpenIMEvent {
  final String conversationID;
  
  ConversationDeletedEvent(this.conversationID);
  
  @override
  String toString() => 'ConversationDeletedEvent(conversationID: $conversationID)';
}

/// Conversation read event
class ConversationReadEvent extends OpenIMEvent {
  final String conversationID;
  final int readCount;
  
  ConversationReadEvent({
    required this.conversationID,
    required this.readCount,
  });
  
  @override
  String toString() => 'ConversationReadEvent(conversationID: $conversationID, readCount: $readCount)';
}