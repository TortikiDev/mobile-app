import 'package:flutter/material.dart';

class ContentShimmer extends StatefulWidget {
  final Color backgroundColor;

  const ContentShimmer({
    Key key,
    this.backgroundColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentShimmerState();
}

class _ContentShimmerState extends State<ContentShimmer>
    with SingleTickerProviderStateMixin {
  final _shimmerWidth = 50.0;

  AnimationController _animationController;
  Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(begin: _shimmerWidth, end: 1000)
        .animate(_animationController)
          ..addListener(() => setState(() {}));
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.hardEdge,
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: _shimmerAnimation.value,
          child: Container(
            width: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  widget.backgroundColor,
                  Colors.white54,
                  widget.backgroundColor,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
