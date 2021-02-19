import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

import '../../../../../utils/string_is_numeric.dart';

class IngredientsChipsInput extends StatelessWidget {
  final ThemeData theme;
  final List<String> initialItems;
  final Function(List<String>) itemsChanged;
  final List<String> unitSuggestions;

  const IngredientsChipsInput({
    Key key,
    this.initialItems = const [],
    @required this.theme,
    @required this.itemsChanged,
    @required this.unitSuggestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChipsInput<String>(
      key: ObjectKey(initialItems),
      keyboardAppearance: theme.brightness,
      maxChips: 30,
      initialValue: initialItems,
      decoration: InputDecoration(hintText: 'сахар 100 г, яйца 2 шт...'),
      allowChipEditing: true,
      findSuggestions: (query) {
        final suggestions = <String>[];
        final trimmedQuery = query.trimRight().trimLeft();
        if (trimmedQuery.isNotEmpty) {
          final lastQueryChar = trimmedQuery.substring(trimmedQuery.length - 1);
          if (lastQueryChar.isNumeric()) {
            final filteredUnitSuggestions =
                unitSuggestions.map((unit) => '$trimmedQuery $unit').toList();
            suggestions.addAll(filteredUnitSuggestions);
          }
          suggestions.add(trimmedQuery);
        }
        return suggestions.toSet().toList();
      },
      onChanged: itemsChanged,
      chipBuilder: (context, state, tag) => InputChip(
          key: ValueKey(tag),
          label: Text(tag),
          onDeleted: () => state.deleteChip(tag),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      suggestionBuilder: (context, state, tag) => ListTile(
        key: ValueKey(tag),
        title: Text(tag),
        onTap: () => state.selectSuggestion(tag),
      ),
    );
  }
}
