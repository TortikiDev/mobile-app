import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/bottom_navigation_bloc/index.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:tortiki/ui/bottom_navigation/bottom_navigation_controller.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';
import 'package:mockito/mockito.dart';

class _MockErrorHandlingBloc extends MockBloc<ErrorHandlingState>
    implements ErrorHandlingBloc {}

class _MockBottomNavigationBloc extends MockBloc<BottomNavigationState>
    implements BottomNavigationBloc {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

class TestBottomNaigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final errorHandlingBloc = _MockErrorHandlingBloc();
    final bottomNavigationBloc = _MockBottomNavigationBloc();
    final bottomNavigationState = BottomNavigationState.initial();
    when(bottomNavigationBloc.state).thenReturn(bottomNavigationState);
    whenListen(bottomNavigationBloc,
        Stream<BottomNavigationState>.value(bottomNavigationState));

    return MultiBlocProvider(
      providers: [
        BlocProvider<ErrorHandlingBloc>(create: (context) => errorHandlingBloc),
        BlocProvider<BottomNavigationBloc>(
            create: (context) => bottomNavigationBloc)
      ],
      child: RepositoryProvider<BookmarkedRecipesRepository>(
          create: (context) => _MockBookmarkedRecipesRepository(),
          child: BottomNavigationController()),
    );
  }
}
