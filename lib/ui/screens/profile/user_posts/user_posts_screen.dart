import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../bloc/user_posts/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../main/feed/post/post_view.dart';
import '../../main/feed/post/post_view_model.dart';

class UserPostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizaitons = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizaitons.publications)),
      body:
          BlocBuilder<UserPostsBloc, UserPostsState>(builder: (context, state) {
        return state.loadingFirstPage
            ? Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(),
                ),
              )
            : _ScrollView(state: state);
      }),
    );
  }
}

class _ScrollView extends StatelessWidget {
  final UserPostsState state;

  const _ScrollView({Key key, @required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Scrollbar(
        child: RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 8),
                itemCount: state.feedItems.length,
                itemBuilder: (context, index) {
                  final model = state.feedItems[index];
                  if (model is PostViewModel) {
                    if ((index == state.feedItems.length - 1) &&
                        !state.loadingNextPage) {
                      BlocProvider.of<UserPostsBloc>(context)
                          .add(LoadNextPage());
                    }
                    return PostView(
                        key: ObjectKey(model),
                        model: model,
                        onAuthorTap: (model) =>
                            Navigator.of(context).maybePop(),
                        onLike: (model) => _likePressed(context, model),
                        onExpandDescription: ({model, isExpanded}) =>
                            _expandDescription(context, model, isExpanded),
                        theme: theme,
                        localizations: localizations);
                  } else if (model is ProgressIndicatorItem) {
                    return SizedBox(
                      height: 40,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  } else {
                    throw UnimplementedError(
                        'Type [${model.runtimeType}] is not'
                        ' implemented for list view builder');
                  }
                }),
            onRefresh: () => _pullToRefreshList(context)));
  }

  Future<void> _pullToRefreshList(BuildContext context) async {
    final completer = Completer();
    final bloc = BlocProvider.of<UserPostsBloc>(context);
    bloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }

  void _likePressed(BuildContext context, PostViewModel model) {
    final event = model.liked ? Unlike(model.id) : Like(model.id);
    BlocProvider.of<UserPostsBloc>(context).add(event);
  }

  void _expandDescription(
    BuildContext context,
    PostViewModel model,
    bool isExpanded,
  ) {
    final event = isExpanded
        ? ExpandDescription(model.id)
        : CollapseDescription(model.id);
    BlocProvider.of<UserPostsBloc>(context).add(event);
  }
}
