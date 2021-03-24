import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/data/repositories/repositories.dart';
import 'package:tortiki/ui/bottom_navigation/bottom_navigation_controller.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:mockito/mockito.dart';

class _MockErrorHandlingBloc extends MockBloc<ErrorHandlingState>
    implements ErrorHandlingBloc {}

class _MockBookmarkedRecipesRepository extends Mock
    implements BookmarkedRecipesRepository {}

class _MockScreenFactory extends Mock implements WidgetFactory {}

class TestBottomNaigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final errorHandlingBloc = _MockErrorHandlingBloc();
    
    final mainScreenFactory = _MockScreenFactory();
    final mapScreenFactory = _MockScreenFactory();
    final bookmarksScreenFactory = _MockScreenFactory();

    return BlocProvider<ErrorHandlingBloc>(
      create: (context) => errorHandlingBloc,
      child: RepositoryProvider<BookmarkedRecipesRepository>(
          create: (context) => _MockBookmarkedRecipesRepository(),
          child: BottomNavigationController(
            mainScreenFactory: mainScreenFactory,
            mapScreenFactory: mapScreenFactory,
            bookmarksScreenFactory: bookmarksScreenFactory,
          )),
    );
  }
}
