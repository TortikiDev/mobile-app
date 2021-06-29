import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/feed/index.dart';
import '../../../reusable/list_items/progress_indicator_item.dart';
import '../../../reusable/loading_indicator.dart';
import '../../profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';
import 'post/post_view.dart';
import 'post/post_view_model.dart';

class FeedScreen extends StatefulWidget {
  final WidgetFactory confectionerProfileScreenFactory;

  const FeedScreen({
    Key? key,
    required this.confectionerProfileScreenFactory,
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
                child: LoadingIndicator(),
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
    Key? key,
    required this.state,
    required this.confectionerProfileScreenFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scrollbar(
        child: RefreshIndicator(
            color: theme.accentColor,
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
                        model: model,
                        onAuthorTap: (model) =>
                            _showAuthorProfile(context, model),
                        onLike: (model) => _likePressed(context, model),
                        onExpandDescription: ({
                          required model,
                          required isExpanded,
                        }) =>
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
                          child: LoadingIndicator(),
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

  void _showAuthorProfile(BuildContext context, PostViewModel model) {
    final screenData = ExternalConfectionerProfileScreenFactoryData(
      confectionerId: model.userId,
      confectionerName: model.userName,
      confectionerGender: model.userGender,
    );
    final screen =
        confectionerProfileScreenFactory.createWidget(data: screenData);
    final route = MaterialPageRoute(builder: (context) => screen);
    Navigator.of(context).push(route);
  }

  void _likePressed(BuildContext context, PostViewModel model) {
    final event = model.liked ? Unlike(model.id) : Like(model.id);
    BlocProvider.of<FeedBloc>(context).add(event);
  }

  void _expandDescription(
    BuildContext context,
    PostViewModel model,
    bool isExpanded,
  ) {
    final event = isExpanded
        ? ExpandDescription(model.id)
        : CollapseDescription(model.id);
    BlocProvider.of<FeedBloc>(context).add(event);
  }
}
