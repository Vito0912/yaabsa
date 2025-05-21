extension DurationExtensions on Duration {
  double get inSecondsPrecise => inMicroseconds / Duration.microsecondsPerSecond;
}