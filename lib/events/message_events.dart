import 'base_event.dart';
import '../models/message.dart';

/// New message received event
class NewMessageEvent extends OpenIMEvent {
  final Message message;
  
  NewMessageEvent(this.message);
  
  @override
  String toString() => 'NewMessageEvent(message: $message)';
}

/// Message sent event
class MessageSentEvent extends OpenIMEvent {
  final Message message;
  
  MessageSentEvent(this.message);
  
  @override
  String toString() => 'MessageSentEvent(message: $message)';
}

/// Message send progress event
class MessageSendProgressEvent extends OpenIMEvent {
  final String clientMsgID;
  final int progress; // 0-100
  
  MessageSendProgressEvent({
    required this.clientMsgID,
    required this.progress,
  });
  
  @override
  String toString() => 'MessageSendProgressEvent(clientMsgID: $clientMsgID, progress: $progress)';
}

/// Message revoked event
class MessageRevokedEvent extends OpenIMEvent {
  final String clientMsgID;
  final String revokerID;
  final String revokerNickname;
  final int revokeTime;
  
  MessageRevokedEvent({
    required this.clientMsgID,
    required this.revokerID,
    required this.revokerNickname,
    required this.revokeTime,
  });
  
  @override
  String toString() => 'MessageRevokedEvent(clientMsgID: $clientMsgID, revokerID: $revokerID)';
}

/// Message deleted event
class MessageDeletedEvent extends OpenIMEvent {
  final String clientMsgID;
  
  MessageDeletedEvent(this.clientMsgID);
  
  @override
  String toString() => 'MessageDeletedEvent(clientMsgID: $clientMsgID)';
}