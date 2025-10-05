/// Login status enumeration
enum LoginStatus {
  logout(1),
  logging(2),
  success(3),
  failed(4);
  
  const LoginStatus(this.value);
  final int value;
  
  static LoginStatus fromValue(int value) {
    return LoginStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => LoginStatus.logout,
    );
  }
  
  bool get isLoggedIn => this == LoginStatus.success;
  bool get isLoggingIn => this == LoginStatus.logging;
  bool get isLoggedOut => this == LoginStatus.logout;
  bool get isFailed => this == LoginStatus.failed;
}