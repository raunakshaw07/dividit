class AppResponse {
  final String status;
  final int success;
  final String? message;
  final String? error;
  final dynamic user;

  AppResponse({
    required this.status,
    required this.success,
    this.message,
    this.error,
    this.user,
  });

  static AppResponse setError(String err) {
    return AppResponse(
      status: "failed",
      success: 0,
      message: null,
      error: err.toString(),
      user: null,
    );
  }

  static AppResponse setSuccess(String message, dynamic user) {
    return AppResponse(
      status: "success",
      success: 1,
      message: message,
      error: null,
      user: user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "status": status,
      "success": success,
      "message": message,
      "error": error,
      "user": user,
    };
  }
}
