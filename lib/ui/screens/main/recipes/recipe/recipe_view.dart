import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../../../../../utils/iterable_safe_element_at.dart';
import '../../../../reusable/complexity_cherries_widget.dart';
import 'recipe_view_model.dart';

class RecipeView extends StatelessWidget {
  final RecipeViewModel model;
  final ThemeData theme;
  final Function(RecipeViewModel)? addToBookmarks;
  final Function(RecipeViewModel)? showDetails;

  const RecipeView({
    Key? key,
    required this.model,
    required this.theme,
    this.addToBookmarks,
    this.showDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDetails?.call(model),
      child: SizedBox(
        height: 258,
        child: Stack(
          children: [
            Positioned.fill(
              child: model.imageUrls.safeElementAt(0) != null
                  ? CachedNetworkImage(
                      imageUrl: model.imageUrls.first,
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white54,
                      Colors.black54,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              left: 16,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: theme.textTheme.headline4,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ComplexityCherriesWidget(
                        complexity: model.complexity,
                        cherryColor: theme.colorScheme.primary,
                        textColor: theme.colorScheme.background,
                      ),
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
                          model.isInBookmarks
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sharePressed() {
    // TODO: specify actual base url
    final baseUrl = 'https://tortiki.ru';
    final postUrl = '$baseUrl/recipe/${model.id}';
    Share.share(postUrl);
  }
}
