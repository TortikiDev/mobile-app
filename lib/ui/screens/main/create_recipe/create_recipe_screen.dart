import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_recipe/index.dart';

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
                title: Text(localizations.newRecipe,
                    style: theme.textTheme.headline6),
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
                            onChanged: (value) => _titleChanged(context, value),
                          ),
                          Text(localizations.photo,
                              style: theme.textTheme.subtitle1),
                        ]),
                  ),
                ))));
  }

  void _createPost(BuildContext context) {
    final event = CreateRecipe();
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }

  void _titleChanged(BuildContext context, String text) {
    final event = TitleChanged(text);
    BlocProvider.of<CreateRecipeBloc>(context).add(event);
  }
}
