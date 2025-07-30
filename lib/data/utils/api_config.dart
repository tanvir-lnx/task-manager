class ApiConfig {
  static const String baseUrl = 'http://35.73.30.144:2005/api/v1';
  
  static const String registration = '/Registration';
  static const String login = '/Login';
  static const String profileUpdate = '/ProfileUpdate';
  static const String profileDetails = '/ProfileDetails';
  static const String recoverVerifyEmail = '/RecoverVerifyEmail';
  static const String recoverVerifyOtp = '/RecoverVerifyOtp';
  static const String recoverResetPassword = '/RecoverResetPassword';
  
  static const String createTask = '/createTask';
  static const String deleteTask = '/deleteTask';
  static const String updateTaskStatus = '/updateTaskStatus';
  static const String listTaskByStatus = '/listTaskByStatus';
  static const String taskStatusCount = '/taskStatusCount';
}