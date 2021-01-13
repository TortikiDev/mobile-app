import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../reusable/complexity_cherries_widget.dart';
import 'recipe_view_model.dart';

class RecipeView extends StatelessWidget {
  final RecipeViewModel model;
  final ThemeData theme;
  const RecipeView({Key key, @required this.model, @required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: model.imageUrl,
            fit: BoxFit.cover,
          ),
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
                    ComplexityCherriesWidget(complexity: model.complexity),
                    Spacer(),
                    IconButton(
                      onPressed: _share,
                      icon: Icon(
                        Icons.share,
                        color: theme.colorScheme.background,
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: _addToBookmarks,
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
            ))
      ],
    );
  }

  void _share() {
    print('share');
  }

  void _addToBookmarks() {
    print('add to bookmarks');
  }
}
