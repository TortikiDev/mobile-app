import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:tortiki/bloc/feed/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/feed/feed_screen.dart';

class _MockFeedBloc extends Mock implements FeedBloc {}

class _MockConfectionerProfileScreenFactory extends Mock
    implements WidgetFactory {}

class TestFeedScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final feedBloc = _MockFeedBloc();
    final feedInitialState = FeedState.initial();
    when(feedBloc.state).thenReturn(feedInitialState);
    when(feedBloc.stream).thenAnswer(
        (realInvocation) => Stream<FeedState>.value(feedInitialState));

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
