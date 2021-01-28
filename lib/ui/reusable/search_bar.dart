import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary,
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            color: theme.colorScheme.onPrimary,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.of(context).pop();
            },
          ),
          suffixIcon: IconButton(
            color: theme.colorScheme.onPrimary,
            icon: Icon(Icons.clear),
            onPressed: () {
              textController.clear();
            },
          ),
        ),
      ),
    );
  }
}
