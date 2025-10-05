/// Connection state information
class ConnectionState {
  final bool isConnected;
  final String? reason;
  final int timestamp;
  
  const ConnectionState({
    required this.isConnected,
    this.reason,
    required this.timestamp,
  });
  
  factory ConnectionState.fromJson(Map<String, dynamic> json) => ConnectionState(
    isConnected: json['isConnected'] ?? false,
    reason: json['reason'],
    timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
  );
  
  Map<String, dynamic> toJson() => {
    'isConnected': isConnected,
    'reason': reason,
    'timestamp': timestamp,
  };
  
  @override
  String toString() => 'ConnectionState(isConnected: $isConnected, reason: $reason)';
}