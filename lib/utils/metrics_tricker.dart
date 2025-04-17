import 'package:mindful_mate/utils/error_logger.dart';

class MetricsTracker {
  int totalOps = 0;
  int errors = 0;

  void record(bool success) {
    totalOps++;
    if (!success) errors++;
    log('Error Rate: ${(errors / totalOps * 100).toStringAsFixed(2)}% ($errors/$totalOps)');
  }
}

final metricsTracker = MetricsTracker();