/// Message types
enum MessageType {
  text(101),
  image(102),
  audio(103),
  video(104),
  file(105),
  location(106),
  custom(107),
  merge(108),
  forward(109),
  card(110);
  
  const MessageType(this.value);
  final int value;
  
  static MessageType fromValue(int value) {
    return MessageType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => MessageType.text,
    );
  }
}

/// Message status
enum MessageStatus {
  sending(1),
  sendSuccess(2),
  sendFailed(3),
  deleted(4),
  revoked(5);
  
  const MessageStatus(this.value);
  final int value;
  
  static MessageStatus fromValue(int value) {
    return MessageStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => MessageStatus.sendSuccess,
    );
  }
}

/// Enhanced message model
class Message {
  final String clientMsgID;
  final String serverMsgID;
  final int createTime;
  final int sendTime;
  final String sendID;
  final String recvID;
  final String? groupID;
  final MessageType msgType;
  final int platformID;
  final String senderNickname;
  final String senderFaceUrl;
  final String content;
  final int seq;
  final bool isRead;
  final MessageStatus status;
  final String? offlinePushInfo;
  final Map<String, dynamic>? attachedInfo;
  final String? ex;
  
  const Message({
    required this.clientMsgID,
    required this.serverMsgID,
    required this.createTime,
    required this.sendTime,
    required this.sendID,
    required this.recvID,
    this.groupID,
    required this.msgType,
    required this.platformID,
    required this.senderNickname,
    required this.senderFaceUrl,
    required this.content,
    required this.seq,
    required this.isRead,
    required this.status,
    this.offlinePushInfo,
    this.attachedInfo,
    this.ex,
  });
  
  factory Message.fromJson(Map<String, dynamic> json) => Message(
    clientMsgID: json['clientMsgID'] ?? '',
    serverMsgID: json['serverMsgID'] ?? '',
    createTime: json['createTime'] ?? 0,
    sendTime: json['sendTime'] ?? 0,
    sendID: json['sendID'] ?? '',
    recvID: json['recvID'] ?? '',
    groupID: json['groupID'],
    msgType: MessageType.fromValue(json['contentType'] ?? 101),
    platformID: json['platformID'] ?? 0,
    senderNickname: json['senderNickname'] ?? '',
    senderFaceUrl: json['senderFaceUrl'] ?? '',
    content: json['content'] ?? '',
    seq: json['seq'] ?? 0,
    isRead: json['isRead'] ?? false,
    status: MessageStatus.fromValue(json['status'] ?? 2),
    offlinePushInfo: json['offlinePushInfo'],
    attachedInfo: json['attachedInfo']?.cast<String, dynamic>(),
    ex: json['ex'],
  );
  
  Map<String, dynamic> toJson() => {
    'clientMsgID': clientMsgID,
    'serverMsgID': serverMsgID,
    'createTime': createTime,
    'sendTime': sendTime,
    'sendID': sendID,
    'recvID': recvID,
    'groupID': groupID,
    'contentType': msgType.value,
    'platformID': platformID,
    'senderNickname': senderNickname,
    'senderFaceUrl': senderFaceUrl,
    'content': content,
    'seq': seq,
    'isRead': isRead,
    'status': status.value,
    'offlinePushInfo': offlinePushInfo,
    'attachedInfo': attachedInfo,
    'ex': ex,
  };
  
  /// Check if this is a group message
  bool get isGroupMessage => groupID != null && groupID!.isNotEmpty;
  
  /// Check if this is a private message
  bool get isPrivateMessage => !isGroupMessage;
  
  @override
  String toString() => 'Message(clientMsgID: $clientMsgID, msgType: $msgType, content: $content)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          clientMsgID == other.clientMsgID;
  
  @override
  int get hashCode => clientMsgID.hashCode;
}