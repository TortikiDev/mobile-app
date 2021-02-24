import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_recipe/index.dart';

import 'components/complexity_stepper.dart';
import 'components/ingredients_chips_input.dart';

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
                    ComplexityStepper(complexity: state.complexity),
                    SizedBox(height: 24),
                    TextField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: localizations.shortDescription,
                      ),
                      onChanged: (value) => _descriptionChanged(context, value),
                    ),
                    SizedBox(height: 24),
                    Text(
                      localizations.ingredients,
                      style: theme.textTheme.subtitle1,
                    ),
                    SizedBox(height: 16),
                    IngredientsChipsInput(
                      theme: theme,
                      itemsChanged: (ingredients) =>
                          _ingredientsChanged(context, ingredients),
                      unitSuggestions: [
                        localizations.grams,
                        localizations.milliliters,
                        localizations.pcs,
                      ],
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
                      onChanged: (value) =>
                          _cookingStepsChanged(context, value),
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
    final event = DescriptionChanged(text);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }

  void _ingredientsChanged(BuildContext context, List<String> ingredients) {
    final event = IngredientsChanged(ingredients);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }

  void _cookingStepsChanged(BuildContext context, String text) {
    final event = CookingStepsChanged(text);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }
}
