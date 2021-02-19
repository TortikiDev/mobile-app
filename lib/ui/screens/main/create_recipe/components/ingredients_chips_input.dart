import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';

import '../../../../../utils/string_is_numeric.dart';

class IngredientsChipsInput extends StatelessWidget {
  final ThemeData theme;
  final List<String> initialItems;
  final Function(List<String>) itemsChanged;
  final List<String> itemSuggestions;
  final List<String> unitSuggestions;

  const IngredientsChipsInput({
    Key key,
    this.initialItems = const [],
    @required this.theme,
    @required this.itemsChanged,
    @required this.itemSuggestions,
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
        List<String> suggestions;
        final trimmedQuery = query.trimRight().trimLeft();
        final lastQueryChar = trimmedQuery.substring(trimmedQuery.length - 1);
        if (lastQueryChar.isNumeric()) {
          suggestions =
              unitSuggestions.map((unit) => '$trimmedQuery $unit').toList();
        } else {
          suggestions = itemSuggestions
              .where((e) => e.contains(trimmedQuery))
              .toList()
              .sublist(0, 2);
        }
        suggestions.add(trimmedQuery);
        return suggestions;
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
