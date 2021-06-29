import 'package:flutter/material.dart';

class ContentShimmer extends StatefulWidget {
  final Color backgroundColor;

  const ContentShimmer({
    Key? key,
    this.backgroundColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentShimmerState();
}

class _ContentShimmerState extends State<ContentShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      reverseDuration: Duration(milliseconds: 800),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: widget.backgroundColor,
      end: widget.backgroundColor.withAlpha(120),
    ).animate(_animationController)
      ..addListener(() => setState(() {}));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _colorAnimation.value,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      clipBehavior: Clip.hardEdge,
    );
  }
}
