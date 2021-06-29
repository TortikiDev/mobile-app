import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../bloc/recipe_details/index.dart';
import '../../../data/http_client/responses/responses.dart';

class VoteWidget extends StatelessWidget {
  final int voteResult;
  final TickerProvider vsync;

  const VoteWidget({Key? key, required this.voteResult, required this.vsync})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        AnimatedSize(
          vsync: vsync,
          duration: Duration(milliseconds: 200),
          child: SizedBox(
            height: voteResult == VoteResult.unvoted ? 40 : 0,
            child: Center(
              child: Text(
                localizations.doYouLikeThisRecipe,
                style: theme.textTheme.subtitle2?.copyWith(color: Colors.grey),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.thumb_up_alt_rounded),
              color: voteResult == VoteResult.votedUp
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondaryVariant,
              iconSize: 48,
              onPressed: () {
                BlocProvider.of<RecipeDetailsBloc>(context).add(VoteUp());
              },
            ),
            SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.thumb_down_alt_rounded),
              color: voteResult == VoteResult.votedDown
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.secondaryVariant,
              iconSize: 48,
              onPressed: () {
                BlocProvider.of<RecipeDetailsBloc>(context).add(VoteDown());
              },
            ),
          ],
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
