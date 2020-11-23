import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText(this.text,
      {Key key,
      @required this.readMoreText,
      @required this.readLessText,
      @required this.theme,
      this.trimLines = 2,
      this.initialExpandedValue = false,
      this.onExpand})
      : assert(text != null),
        super(key: key);

  final String text;
  final String readMoreText;
  final String readLessText;
  final ThemeData theme;
  final int trimLines;
  final bool initialExpandedValue;
  final Function(bool) onExpand;

  @override
  ExpandableTextState createState() =>
      ExpandableTextState(expanded: initialExpandedValue);
}

class ExpandableTextState extends State<ExpandableText> {
  bool _expanded;
  TapGestureRecognizer _readMoreTapGesture;

  ExpandableTextState({@required bool expanded}) : _expanded = expanded;

  @override
  void initState() {
    super.initState();
    _readMoreTapGesture = TapGestureRecognizer()..onTap = _onTapExpand;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.theme.textTheme.bodyText2;
    final readMoreTextStyle = widget.theme.textTheme.bodyText2
        .copyWith(color: widget.theme.colorScheme.onSurface);

    final readMoreTextSpan = TextSpan(
        text:
            _expanded ? "  ${widget.readLessText}" : "  ${widget.readMoreText}",
        style: readMoreTextStyle,
        recognizer: _readMoreTapGesture);
    final elipsisTextSpan = TextSpan(text: "...", style: textStyle);

    final result = LayoutBuilder(
      builder: (context, constraints) {
        assert(constraints.hasBoundedWidth);
        final maxWidth = constraints.maxWidth;
        final text = TextSpan(
          text: widget.text,
        );
        final textPainter = TextPainter(
          text: readMoreTextSpan,
          textDirection: TextDirection.rtl,
          maxLines: widget.trimLines,
          ellipsis: '...',
        );

        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final readMoreSize = textPainter.size;

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - readMoreSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);

        TextSpan textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _expanded ? widget.text : widget.text.substring(0, endIndex),
            style: textStyle,
            children: _expanded
                ? [readMoreTextSpan]
                : [elipsisTextSpan, readMoreTextSpan],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
            style: textStyle,
          );
        }

        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );

    return result;
  }

  void _onTapExpand() {
    final newExpandedValue = !_expanded;
    setState(() => _expanded = !newExpandedValue);
    widget.onExpand(newExpandedValue);
  }
}
