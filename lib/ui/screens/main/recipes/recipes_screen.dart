import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_localizations.dart';
import '../../../../bloc/recipes/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../feed/post/post_view.dart';
import '../feed/post/post_view_model.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen>
    with AutomaticKeepAliveClientMixin<RecipesScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<RecipesBloc, RecipesState>(builder: (context, state) {
      return state.loadingFirstPage
          ? Center(
              child: SizedBox(
                  width: 32, height: 32, child: CircularProgressIndicator()))
          : _ScrollView(state: state);
    });
  }
}

class _ScrollView extends StatelessWidget {
  final RecipesState state;

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
                      BlocProvider.of<RecipesBloc>(context).add(LoadNextPage());
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
  }

  Future<void> _pullToRefreshList(BuildContext context) async {
    final completer = Completer();
    final feedBloc = BlocProvider.of<RecipesBloc>(context);
    feedBloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }
}
