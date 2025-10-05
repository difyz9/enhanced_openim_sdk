import 'base_event.dart';
import '../models/connection_state.dart';

/// Connection state changed event
class ConnectionStateChangedEvent extends OpenIMEvent {
  final ConnectionState state;
  
  ConnectionStateChangedEvent(this.state);
  
  @override
  String toString() => 'ConnectionStateChangedEvent(state: $state)';
}

/// User kicked offline event
class UserKickedOfflineEvent extends OpenIMEvent {
  final String? reason;
  
  UserKickedOfflineEvent([this.reason]);
  
  @override
  String toString() => 'UserKickedOfflineEvent(reason: $reason)';
}

/// User token expired event
class UserTokenExpiredEvent extends OpenIMEvent {
  UserTokenExpiredEvent();
  
  @override
  String toString() => 'UserTokenExpiredEvent()';
}

/// Connection success event
class ConnectionSuccessEvent extends OpenIMEvent {
  ConnectionSuccessEvent();
  
  @override
  String toString() => 'ConnectionSuccessEvent()';
}

/// Connection failed event
class ConnectionFailedEvent extends OpenIMEvent {
  final String? reason;
  final int? errorCode;
  
  ConnectionFailedEvent({this.reason, this.errorCode});
  
  @override
  String toString() => 'ConnectionFailedEvent(reason: $reason, errorCode: $errorCode)';
}