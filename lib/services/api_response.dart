class ApiResponse<T> {
  T? data;
  bool? error;
  String? errorMessage;
  ApiResponse({this.data, this.error = false, this.errorMessage});

  @override
  String toString() {
    return 'ApiResponse{data: ${data.toString()}, error: $error, errorMessage: $errorMessage}';
  }
}
