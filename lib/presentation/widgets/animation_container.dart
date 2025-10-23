import 'package:flutter/material.dart';

enum AnimationDirection { fromRight, fromLeft, fromTop, fromBottom }

class AnimationContainer extends StatefulWidget {
  final Widget child;
  final AnimationDirection direction;
  final Duration duration;
  final Duration delay;

  const AnimationContainer({
    super.key,
    required this.child,
    this.direction = AnimationDirection.fromRight,
    this.duration = const Duration(milliseconds: 500),
    this.delay = Duration.zero,
  });

  factory AnimationContainer.fromRight({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return AnimationContainer(
      direction: AnimationDirection.fromRight,
      duration: duration,
      delay: delay,
      child: child,
    );
  }

  factory AnimationContainer.fromLeft({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return AnimationContainer(
      direction: AnimationDirection.fromLeft,
      duration: duration,
      delay: delay,
      child: child,
    );
  }

  factory AnimationContainer.fromTop({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return AnimationContainer(
      direction: AnimationDirection.fromTop,
      duration: duration,
      delay: delay,
      child: child,
    );
  }

  factory AnimationContainer.fromBottom({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
    Duration delay = Duration.zero,
  }) {
    return AnimationContainer(
      direction: AnimationDirection.fromBottom,
      duration: duration,
      delay: delay,
      child: child,
    );
  }

  @override
  State<AnimationContainer> createState() => _AnimationContainerState();
}

class _AnimationContainerState extends State<AnimationContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Offset _getOffset() {
    switch (widget.direction) {
      case AnimationDirection.fromRight:
        return Offset(1.0, 0.0);
      case AnimationDirection.fromLeft:
        return Offset(-1.0, 0.0);
      case AnimationDirection.fromTop:
        return Offset(0.0, -1.0);
      case AnimationDirection.fromBottom:
        return Offset(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: widget.duration,
      builder: (context, value, child) {
        final offset = _getOffset();
        final translateX = offset.dx * (1 - value) * 100;
        final translateY = offset.dy * (1 - value) * 100;

        return Transform.translate(
          offset: Offset(translateX, translateY),
          child: Opacity(opacity: value, child: widget.child),
        );
      },
    );
  }
}
