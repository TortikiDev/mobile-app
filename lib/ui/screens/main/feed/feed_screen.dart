import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/base_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/feed/index.dart';
import 'list_items/post/post_view.dart';
import 'list_items/post/post_view_model.dart';
import 'list_items/progress_indicator_item.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return state.loadingFirstPage
          ? Center(
              child: SizedBox(width: 32, child: CircularProgressIndicator()))
          : Scrollbar(
              child: RefreshIndicator(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 8),
                      itemCount: state.feedItems.length,
                      itemBuilder: (context, index) {
                        final model = state.feedItems[index];
                        if (model is PostViewModel) {
                          if ((index == state.feedItems.length - 1) &&
                              !state.loadingNextPage) {
                            BlocProvider.of<FeedBloc>(context)
                                .add(LoadNextPage());
                          }
                          return PostView(
                              key: ObjectKey(model),
                              model: model,
                              theme: theme,
                              localizations: localizations);
                        } else if (model is ProgressIndicatorItem) {
                          return SizedBox(
                              height: 40,
                              child: Center(
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator())));
                        } else {
                          throw UnimplementedError(
                              'Type [${model.runtimeType}] is not'
                              ' implemented for list view builder');
                        }
                      }),
                  onRefresh: () => _pullToRefreshList(context)));
    });
  }

  Future<void> _pullToRefreshList(BuildContext context) async {
    final completer = Completer();
    final feedBloc = BlocProvider.of<FeedBloc>(context);
    feedBloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }
}
