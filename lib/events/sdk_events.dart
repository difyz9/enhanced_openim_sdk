import 'base_event.dart';

/// SDK initialized event
class SDKInitializedEvent extends OpenIMEvent {
  SDKInitializedEvent();
  
  @override
  String toString() => 'SDKInitializedEvent()';
}

/// User logged in event
class UserLoginEvent extends OpenIMEvent {
  final String userID;
  
  UserLoginEvent(this.userID);
  
  @override
  String toString() => 'UserLoginEvent(userID: $userID)';
}

/// User logged out event
class UserLogoutEvent extends OpenIMEvent {
  UserLogoutEvent();
  
  @override
  String toString() => 'UserLogoutEvent()';
}