import 'package:flutter/material.dart';

class ComplexityCherriesWidget extends StatelessWidget {
  final int _cherryCount = 5;
  final double complexity;
  final Color cherryColor;
  final Color textColor;

  ComplexityCherriesWidget({
    required this.complexity,
    required this.cherryColor,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final normalizedComplexity = complexity * _cherryCount;

    final rowChildren = List.generate(
      _cherryCount,
      (index) => _buildCherry(cherryColor, index, normalizedComplexity),
    );
    rowChildren.add(
      Padding(
        padding: EdgeInsets.only(top: 4, left: 12),
        child: Text(
          normalizedComplexity.toStringAsFixed(1),
          style: theme.textTheme.subtitle1?.copyWith(color: textColor),
        ),
      ),
    );
    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowChildren,
      ),
    );
  }

  Widget _buildCherry(Color color, int index, double complexity) {
    AssetImage asset;

    if (index >= complexity) {
      asset = AssetImage('assets/cherry/cherry_empty.png');
    } else if (index > complexity - 1 && index < complexity) {
      asset = AssetImage('assets/cherry/cherry_half.png');
    } else {
      asset = AssetImage('assets/cherry/cherry_filled.png');
    }
    return Padding(
      padding: EdgeInsets.only(right: 4),
      child: ImageIcon(
        asset,
        size: 18,
        color: color,
      ),
    );
  }
}
