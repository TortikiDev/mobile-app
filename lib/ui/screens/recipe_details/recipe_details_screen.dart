import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../reusable/images_collection.dart';

class RecipeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
            builder: (context, state) => CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 270,
                  stretch: true,
                  pinned: true,
                  toolbarHeight: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        ImagesCollection(urls: state.recipe?.imageUrls ?? []),
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
          ),
          Positioned(
            top: 8,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
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
          ),
        ],
      ),
    );
  }
}
