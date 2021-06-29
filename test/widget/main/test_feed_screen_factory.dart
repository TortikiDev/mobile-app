import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/feed/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/feed/feed_screen.dart';

class _MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {
}

class _MockConfectionerProfileScreenFactory extends Mock
    implements WidgetFactory {}

class TestFeedScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedInitialState = FeedState.initial();
    registerFallbackValue(feedInitialState);
    registerFallbackValue(BlocInit());
    final feedBloc = _MockFeedBloc();
    when(() => feedBloc.state).thenReturn(feedInitialState);

    final confectionerProfileScreenFactory =
        _MockConfectionerProfileScreenFactory();

    return BlocProvider<FeedBloc>(
      create: (context) => feedBloc,
      child: FeedScreen(
        confectionerProfileScreenFactory: confectionerProfileScreenFactory,
      ),
    );
  }
}
