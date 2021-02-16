import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_recipe/index.dart';
import '../../../reusable/show_dialog_mixin.dart';

class CreateRecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return BlocConsumer<CreateRecipeBloc, CreateRecipeState>(
      listenWhen: (previous, current) => current.recipeSuccessfulyCreated,
      listener: (context, state) => Navigator.of(context).maybePop(),
      builder: (context, state) => Scaffold(
        appBar: AppBar(
            title:
                Text(localizations.newRecipe, style: theme.textTheme.headline6),
            actions: state.creatingRecipe
                ? [
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    )
                  ]
                : [
                    IconButton(
                      icon: Icon(Icons.send),
                      tooltip: localizations.newPost,
                      onPressed: state.canCreateRecipe
                          ? () => _createPost(context)
                          : null,
                    ),
                  ]),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 16.0, right: 16.0, left: 16.0, bottom: 32.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      maxLength: 50,
                      maxLines: 1,
                      decoration: InputDecoration(hintText: localizations.name),
                      onChanged: (value) => _titleChanged(context, value),
                    ),
                    Text(
                      localizations.complexityAndDescription,
                      style: theme.textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    _ComplexityStepper(complexity: state.complexity),
                    SizedBox(height: 24),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localizations.description,
                      ),
                      onChanged: (value) => _descriptionChanged(context, value),
                    ),
                    SizedBox(height: 24),
                    Text(
                      localizations.ingredients,
                      style: theme.textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localizations.addIngredients,
                      ),
                      onChanged: (value) => _descriptionChanged(context, value),
                    ),
                    SizedBox(height: 24),
                    Text(
                      localizations.cooking,
                      style: theme.textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localizations.cookingSteps,
                      ),
                      onChanged: (value) => _descriptionChanged(context, value),
                    ),
                    SizedBox(height: 24),
                    Text(
                      localizations.photo,
                      style: theme.textTheme.subtitle1,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _createPost(BuildContext context) {
    final event = CreateRecipe();
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }

  void _titleChanged(BuildContext context, String text) {
    final event = TitleChanged(text);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }

  void _descriptionChanged(BuildContext context, String text) {
    final event = DescritpionChanged(text);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }
}

class _ComplexityStepper extends StatelessWidget with ShowDialogMixin {
  final double complexity;

  const _ComplexityStepper({Key key, @required this.complexity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        GestureDetector(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
          onTap: () =>
              BlocProvider.of<CreateRecipeBloc>(context).add(MinusComplexity()),
        ),
        SizedBox(width: 8),
        Text(
          complexity.toStringAsFixed(1),
          style: theme.textTheme.subtitle1,
        ),
        SizedBox(width: 8),
        GestureDetector(
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add,
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ),
          onTap: () =>
              BlocProvider.of<CreateRecipeBloc>(context).add(PlusComplexity()),
        ),
        Spacer(),
        RatingBar(
          initialRating: complexity,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          onRatingUpdate: null,
          ratingWidget: RatingWidget(
            full: _getRatingImage('assets/cherry/cherry_filled.png', theme),
            half: _getRatingImage('assets/cherry/cherry_half.png', theme),
            empty: _getRatingImage('assets/cherry/cherry_empty.png', theme),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        ),
        SizedBox(width: 8),
        GestureDetector(
          child: Icon(
            Icons.info,
            size: 18,
            color: theme.colorScheme.onSurface,
          ),
          onTap: () => _showComplexityInfoDialog(context),
        ),
      ],
    );
  }

  Image _getRatingImage(String name, ThemeData theme) => Image.asset(
        name,
        color: theme.colorScheme.onPrimary,
      );

  void _showComplexityInfoDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showSimpleDialog(context: context, message: localizations.complexityPrompt);
  }
}
