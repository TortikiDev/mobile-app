import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app_localizations.dart';

import '../../../../bloc/feed/index.dart';
import 'post/post_view.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return ListView.builder(
          itemCount: state.postsViewModels.length,
          itemBuilder: (context, index) {
            final model = state.postsViewModels[index];
            return PostView(
                model: model, theme: theme, localizations: localizations);
          });
    });
  }
}
