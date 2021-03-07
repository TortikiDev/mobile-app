import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';

class RecipeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
      builder: (context, state) => Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 270,
                  stretch: true,
                  pinned: true,
                  toolbarHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: state.recipe?.imageUrls?.first != null
                        ? CachedNetworkImage(
                            imageUrl: state.recipe?.imageUrls?.first,
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) => ListTile(
                      title: Text("Index: $index"),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              top: 56,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 28,
                    height: 28,
                    color: Colors.black54,
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
