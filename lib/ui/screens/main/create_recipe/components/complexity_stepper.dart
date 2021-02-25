

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../../app_localizations.dart';
import '../../../../../bloc/create_recipe/index.dart';
import '../../../../reusable/show_dialog_mixin.dart';

class ComplexityStepper extends StatelessWidget with ShowDialogMixin {
  final double complexity;

  const ComplexityStepper({Key key, @required this.complexity})
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