import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../../reusable/complexity_cherries_widget.dart';
import '../../../reusable/disclosure_with_image_view.dart';
import 'recipe_header_view_model.dart';

class RecipeHeader extends StatelessWidget {
  final RecipeHeaderViewModel model;
  final Function(RecipeHeaderViewModel) addToBookmarks;

  const RecipeHeader({
    Key key,
    @required this.model,
    this.addToBookmarks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.title,
          style: theme.textTheme.headline4,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            ComplexityCherriesWidget(complexity: model.complexity),
            Spacer(),
            IconButton(
              onPressed: _sharePressed,
              icon: Icon(
                Icons.share,
                color: theme.colorScheme.background,
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () => addToBookmarks?.call(model),
              icon: Icon(
                model.isInBookmarks ? Icons.bookmark : Icons.bookmark_border,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(width: 16),
        Divider(),
        DisclosureWithImageView(
            title: model.authorName, imageUrl: model.authorAvatarUrl),
        Divider(),
      ],
    );
  }

  void _sharePressed({@required recipeId}) {
    // TODO: specify actual base url
    final baseUrl = 'https://tortiki.ru';
    final postUrl = '$baseUrl/recipe/$recipeId';
    Share.share(postUrl);
  }
}
