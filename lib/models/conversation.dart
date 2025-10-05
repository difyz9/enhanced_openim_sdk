import 'message.dart';

/// Conversation types
enum ConversationType {
  singleChat(1),
  groupChat(2),
  superGroupChat(3);
  
  const ConversationType(this.value);
  final int value;
  
  static ConversationType fromValue(int value) {
    return ConversationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => ConversationType.singleChat,
    );
  }
}

/// Enhanced conversation model
class Conversation {
  final String conversationID;
  final ConversationType conversationType;
  final String userID;
  final String groupID;
  final String showName;
  final String faceURL;
  final int recvMsgOpt;
  final int unreadCount;
  final int groupAtType;
  final Message? latestMsg;
  final int latestMsgSendTime;
  final String draftText;
  final int draftTextTime;
  final bool isPinned;
  final bool isPrivateChat;
  final int burnDuration;
  final bool isNotInGroup;
  final String? ex;
  
  const Conversation({
    required this.conversationID,
    required this.conversationType,
    required this.userID,
    required this.groupID,
    required this.showName,
    required this.faceURL,
    required this.recvMsgOpt,
    required this.unreadCount,
    required this.groupAtType,
    this.latestMsg,
    required this.latestMsgSendTime,
    required this.draftText,
    required this.draftTextTime,
    required this.isPinned,
    required this.isPrivateChat,
    required this.burnDuration,
    required this.isNotInGroup,
    this.ex,
  });
  
  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    conversationID: json['conversationID'] ?? '',
    conversationType: ConversationType.fromValue(json['conversationType'] ?? 1),
    userID: json['userID'] ?? '',
    groupID: json['groupID'] ?? '',
    showName: json['showName'] ?? '',
    faceURL: json['faceURL'] ?? '',
    recvMsgOpt: json['recvMsgOpt'] ?? 0,
    unreadCount: json['unreadCount'] ?? 0,
    groupAtType: json['groupAtType'] ?? 0,
    latestMsg: json['latestMsg'] != null ? Message.fromJson(json['latestMsg']) : null,
    latestMsgSendTime: json['latestMsgSendTime'] ?? 0,
    draftText: json['draftText'] ?? '',
    draftTextTime: json['draftTextTime'] ?? 0,
    isPinned: json['isPinned'] ?? false,
    isPrivateChat: json['isPrivateChat'] ?? false,
    burnDuration: json['burnDuration'] ?? 0,
    isNotInGroup: json['isNotInGroup'] ?? false,
    ex: json['ex'],
  );
  
  Map<String, dynamic> toJson() => {
    'conversationID': conversationID,
    'conversationType': conversationType.value,
    'userID': userID,
    'groupID': groupID,
    'showName': showName,
    'faceURL': faceURL,
    'recvMsgOpt': recvMsgOpt,
    'unreadCount': unreadCount,
    'groupAtType': groupAtType,
    'latestMsg': latestMsg?.toJson(),
    'latestMsgSendTime': latestMsgSendTime,
    'draftText': draftText,
    'draftTextTime': draftTextTime,
    'isPinned': isPinned,
    'isPrivateChat': isPrivateChat,
    'burnDuration': burnDuration,
    'isNotInGroup': isNotInGroup,
    'ex': ex,
  };
  
  /// Check if conversation is muted
  bool get isMuted => recvMsgOpt == 2;
  
  /// Check if conversation has unread messages
  bool get hasUnread => unreadCount > 0;
  
  /// Check if conversation is a group chat
  bool get isGroup => conversationType == ConversationType.groupChat || 
                      conversationType == ConversationType.superGroupChat;
  
  @override
  String toString() => 'Conversation(conversationID: $conversationID, showName: $showName, unreadCount: $unreadCount)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Conversation &&
          runtimeType == other.runtimeType &&
          conversationID == other.conversationID;
  
  @override
  int get hashCode => conversationID.hashCode;
}