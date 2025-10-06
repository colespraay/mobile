import 'package:flutter/material.dart';

class TextShimmer extends StatefulWidget {
  final double width;
  final double height;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;
  final BorderRadius borderRadius;

  const TextShimmer({
    super.key,
    this.width = 100,
    this.height = 20,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.duration = const Duration(milliseconds: 1500),
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<TextShimmer> createState() => _TextShimmerState();
}

class _TextShimmerState extends State<TextShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (_controller.value * 2), 0.0),
              end: Alignment(1.0 + (_controller.value * 2), 0.0),
            ),
          ),
        );
      },
    );
  }
}

class SingleLineExample extends StatelessWidget {
  const SingleLineExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextShimmer(
          width: 200,
          height: 24,
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 16),
        TextShimmer(
          width: 150,
          height: 20,
          baseColor: Colors.blueGrey[200]!,
          highlightColor: Colors.blueGrey[50]!,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
