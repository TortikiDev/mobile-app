import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/create_post/index.dart';

class CreatePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    // TODO: add scaffold body
    return BlocBuilder<CreatePostBloc, CreatePostState>(
        builder: (context, state) => Scaffold(
              appBar: AppBar(
                  title: Text(localizations.badGateway,
                      style: theme.textTheme.headline6),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.send),
                      tooltip: localizations.badGateway,
                      onPressed: () {},
                    ),
                  ]),
            ));
  }
}
