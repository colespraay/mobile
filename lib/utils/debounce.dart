import 'dart:async';

import 'package:flutter/foundation.dart';

class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({this.delay = const Duration(seconds: 1)});

  void call(void Function() callback) {
    _timer?.cancel(); // Cancel previous timer
    _timer = Timer(delay, callback); // Start new timer
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }
}

class IDebouncer {
  final Duration duration;
  Timer? _timer;
  VoidCallback? _latestAction;

  IDebouncer({this.duration = const Duration(milliseconds: 1000)});

  void run({
    required VoidCallback action,
    Duration? duration,
  }) {
    _latestAction = action;
    _timer?.cancel();
    _timer = Timer(duration ?? this.duration, () {
      if (_latestAction == action) {
        action();
      }
    });
  }

  void runImmediately() {
    _timer?.cancel();
    _latestAction?.call();
  }

  void cancel() {
    _timer?.cancel();
    _latestAction = null;
  }

  bool get isRunning => _timer?.isActive == true;
}
