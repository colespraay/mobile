import 'dart:async';

import 'package:flutter/material.dart';

// ============================================================================
// OPTION 1: Simple Countdown Timer (Recommended)
// ============================================================================
class CountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final Color? textColor;

  const CountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
    this.textStyle,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = Duration(seconds: _timeLeft.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  String _formatTime() {
    final hours = _timeLeft.inHours.toString().padLeft(2, '0');
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');

    if (_timeLeft.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(),
      style: widget.textStyle ??
          TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: widget.textColor ?? Colors.black,
          ),
    );
  }
}

// ============================================================================
// OPTION 2: Circular Progress Countdown Timer
// ============================================================================
class CircularCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final double size;
  final Color? progressColor;
  final Color? backgroundColor;
  final Color? textColor;
  final double strokeWidth;

  const CircularCountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
    this.size = 120,
    this.progressColor,
    this.backgroundColor,
    this.textColor,
    this.strokeWidth = 8,
  }) : super(key: key);

  @override
  State<CircularCountdownTimer> createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late Duration _timeLeft;
  late int _totalSeconds;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.duration;
    _totalSeconds = widget.duration.inSeconds;

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.reverse(from: 1.0);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = Duration(seconds: _timeLeft.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress => _timeLeft.inSeconds / _totalSeconds;

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: widget.strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.backgroundColor ?? Colors.grey.withOpacity(0.2),
              ),
            ),
          ),

          // Progress circle
          SizedBox(
            width: widget.size,
            height: widget.size,
            child: CircularProgressIndicator(
              value: _progress,
              strokeWidth: widget.strokeWidth,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.progressColor ?? colorScheme.primary,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),

          // Time text
          Text(
            _formatTime(),
            style: TextStyle(
              fontSize: widget.size * 0.2,
              fontWeight: FontWeight.w800,
              color: widget.textColor ?? colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// OPTION 3: Card-Style Countdown Timer
// ============================================================================
class CardCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final String? title;
  final IconData? icon;

  const CardCountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  State<CardCountdownTimer> createState() => _CardCountdownTimerState();
}

class _CardCountdownTimerState extends State<CardCountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = Duration(seconds: _timeLeft.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hours = _timeLeft.inHours;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary.withOpacity(0.1),
            colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hours > 0) ...[
                _TimeUnit(
                  value: hours,
                  label: 'HRS',
                  colorScheme: colorScheme,
                ),
                const SizedBox(width: 8),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              _TimeUnit(
                value: minutes,
                label: 'MIN',
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 8),
              Text(
                ':',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              _TimeUnit(
                value: seconds,
                label: 'SEC',
                colorScheme: colorScheme,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeUnit extends StatelessWidget {
  final int value;
  final String label;
  final ColorScheme colorScheme;

  const _TimeUnit({
    required this.value,
    required this.label,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withOpacity(0.6),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// OPTION 4: Linear Progress Countdown Timer
// ============================================================================
class LinearCountdownTimer extends StatefulWidget {
  final Duration duration;
  final VoidCallback onComplete;
  final String? message;
  final double height;

  const LinearCountdownTimer({
    Key? key,
    required this.duration,
    required this.onComplete,
    this.message,
    this.height = 60,
  }) : super(key: key);

  @override
  State<LinearCountdownTimer> createState() => _LinearCountdownTimerState();
}

class _LinearCountdownTimerState extends State<LinearCountdownTimer> {
  late Timer _timer;
  late Duration _timeLeft;
  late int _totalSeconds;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.duration;
    _totalSeconds = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft.inSeconds > 0) {
          _timeLeft = Duration(seconds: _timeLeft.inSeconds - 1);
        } else {
          _timer.cancel();
          widget.onComplete();
        }
      });
    });
  }

  String _formatTime() {
    final minutes = (_timeLeft.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_timeLeft.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress => _timeLeft.inSeconds / _totalSeconds;

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: widget.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.message != null)
                Expanded(
                  child: Text(
                    widget.message!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              Text(
                _formatTime(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================
class CountdownExamplesPage extends StatelessWidget {
  const CountdownExamplesPage({Key? key}) : super(key: key);

  void _onTimerComplete() {
    print('Timer completed!');
    // Perform your action here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timers')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Simple Countdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CountdownTimer(
              duration: const Duration(minutes: 5),
              onComplete: _onTimerComplete,
              textColor: Colors.red,
            ),
            const SizedBox(height: 32),
            const Text(
              'Circular Countdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Center(
              child: CircularCountdownTimer(
                duration: const Duration(minutes: 3, seconds: 30),
                onComplete: _onTimerComplete,
                size: 150,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Card Countdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CardCountdownTimer(
              duration: const Duration(hours: 1, minutes: 30, seconds: 45),
              onComplete: _onTimerComplete,
              title: 'Session Expires In',
              icon: Icons.timer,
            ),
            const SizedBox(height: 32),
            const Text(
              'Linear Progress Countdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            LinearCountdownTimer(
              duration: const Duration(minutes: 2),
              onComplete: _onTimerComplete,
              message: 'Verification code expires in',
            ),
          ],
        ),
      ),
    );
  }
}
