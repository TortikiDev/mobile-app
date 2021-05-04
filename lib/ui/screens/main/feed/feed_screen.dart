import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';
import '../../../../bloc/feed/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import 'post/post_view.dart';
import 'post/post_view_model.dart';

class FeedScreen extends StatefulWidget {
  final WidgetFactory confectionerProfileScreenFactory;

  const FeedScreen({
    Key key,
    @required this.confectionerProfileScreenFactory,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin<FeedScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return state.loadingFirstPage
          ? Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
            )
          : _ScrollView(
              state: state,
              confectionerProfileScreenFactory:
                  widget.confectionerProfileScreenFactory,
            );
    });
  }
}

class _ScrollView extends StatelessWidget {
  final FeedState state;
  final WidgetFactory confectionerProfileScreenFactory;

  const _ScrollView({
    Key key,
    @required this.state,
    @required this.confectionerProfileScreenFactory,
  }) : super(key: key);

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
                      BlocProvider.of<FeedBloc>(context).add(LoadNextPage());
                    }
                    return PostView(
                        key: ObjectKey(model),
                        confectionerProfileScreenFactory:
                            confectionerProfileScreenFactory,
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
    final feedBloc = BlocProvider.of<FeedBloc>(context);
    feedBloc.add(PullToRefresh(completer.complete));
    return completer.future;
  }
}
