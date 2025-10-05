/// Base class for all OpenIM events
abstract class OpenIMEvent {
  final DateTime timestamp = DateTime.now();
  
  OpenIMEvent();
  
  @override
  String toString() => '$runtimeType(timestamp: $timestamp)';
}