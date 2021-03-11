import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../../../app_localizations.dart';
import '../../../reusable/complexity_cherries_widget.dart';
import '../../../reusable/disclosure_with_image_view.dart';
import '../../../reusable/show_dialog_mixin.dart';
import 'recipe_header_view_model.dart';

class RecipeHeader extends StatelessWidget with ShowDialogMixin {
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
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            model.title,
            style: theme.textTheme.headline4.copyWith(color: Colors.black),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 16),
              ComplexityCherriesWidget(
                complexity: model.complexity,
                cherryColor: theme.colorScheme.onPrimary,
              ),
              SizedBox(width: 8),
              GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.info,
                    size: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                onTap: () => _showComplexityInfoDialog(context),
              ),
              Spacer(),
              IconButton(
                onPressed: _sharePressed,
                icon: Icon(
                  Icons.share,
                  color: theme.colorScheme.primaryVariant,
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () => addToBookmarks?.call(model),
                icon: Icon(
                  model.isInBookmarks ? Icons.bookmark : Icons.bookmark_border,
                  color: theme.colorScheme.primaryVariant,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
        ),
        SizedBox(height: 16),
        Divider(),
        DisclosureWithImageView(
          title: model.authorName,
          imageUrl: model.authorAvatarUrl,
        ),
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

  void _showComplexityInfoDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showSimpleDialog(context: context, message: localizations.complexityPrompt);
  }
}
