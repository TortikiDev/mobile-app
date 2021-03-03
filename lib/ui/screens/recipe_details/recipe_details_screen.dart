import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/recipe_details/index.dart';

class RecipeDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add scaffold body
    return BlocBuilder<RecipeDetailsBloc, RecipeDetailsState>(
      builder: (context, state) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              flexibleSpace: Header(
                maxHeight: maxHeight,
                minHeight: minHeight,
              ),
              expandedHeight: maxHeight - MediaQuery.of(context).padding.top,
            ),
          ],
        ),
      ),
    );
  }
}
