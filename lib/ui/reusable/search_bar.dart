import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final bool autofocus;
  final Function(String) onTextChanged;
  final Function() onBackArrowPressed;

  SearchBar({
    Key key,
    this.autofocus,
    this.onTextChanged,
    this.onBackArrowPressed,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final textController = TextEditingController();
  var _showClearTextButton = false;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      color: theme.colorScheme.primary,
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: textController,
        onChanged: (text) {
          widget.onTextChanged(text);
          final showClearButton = text.isNotEmpty;
          if (showClearButton != _showClearTextButton) {
            setState(() {
              _showClearTextButton = showClearButton;
            });
          }
        },
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(12, 14, 12, 12),
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: IconButton(
            key: Key('Back button'),
            color: theme.colorScheme.onPrimary,
            icon: Icon(Icons.arrow_back),
            onPressed: widget.onBackArrowPressed,
          ),
          suffixIcon: _showClearTextButton
              ? IconButton(
                  key: Key('Clear text button'),
                  color: theme.colorScheme.onPrimary,
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    textController.clear();
                    widget.onTextChanged('');
                  },
                )
              : null,
        ),
      ),
    );
  }
}
