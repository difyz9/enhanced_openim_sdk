/// User information model
class UserInfo {
  final String userID;
  final String nickname;
  final String faceURL;
  final String? ex;
  final int createTime;
  final int appMangerLevel;
  final int globalRecvMsgOpt;
  
  const UserInfo({
    required this.userID,
    required this.nickname,
    required this.faceURL,
    this.ex,
    required this.createTime,
    required this.appMangerLevel,
    required this.globalRecvMsgOpt,
  });
  
  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    userID: json['userID'] ?? '',
    nickname: json['nickname'] ?? '',
    faceURL: json['faceURL'] ?? '',
    ex: json['ex'],
    createTime: json['createTime'] ?? 0,
    appMangerLevel: json['appMangerLevel'] ?? 0,
    globalRecvMsgOpt: json['globalRecvMsgOpt'] ?? 0,
  );
  
  Map<String, dynamic> toJson() => {
    'userID': userID,
    'nickname': nickname,
    'faceURL': faceURL,
    'ex': ex,
    'createTime': createTime,
    'appMangerLevel': appMangerLevel,
    'globalRecvMsgOpt': globalRecvMsgOpt,
  };
  
  @override
  String toString() => 'UserInfo(userID: $userID, nickname: $nickname)';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfo &&
          runtimeType == other.runtimeType &&
          userID == other.userID;
  
  @override
  int get hashCode => userID.hashCode;
}