class HelperFunctionsFactory {
  static final HelperFunctionsFactory _instance =
      HelperFunctionsFactory._internal();

  HelperFunctionsFactory._internal();

  // getter za factory
  factory HelperFunctionsFactory() {
    return _instance;
  }

  String formatDuration(double distance) {
    int totalTime = distance ~/ 1.6;

    int timeInSeconds = totalTime % 60;

    totalTime = totalTime ~/ 60;
    int timeInMinutes = totalTime % 60;

    totalTime = totalTime ~/ 60;
    int timeInHours = totalTime % 60;

    if (timeInHours > 0) return '${timeInHours}h $timeInMinutes min';
    if (timeInMinutes > 0) return '$timeInMinutes min';
    return '${timeInSeconds}s';
  }
}
