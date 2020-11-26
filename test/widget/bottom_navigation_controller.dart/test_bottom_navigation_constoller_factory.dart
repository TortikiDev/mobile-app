import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/error_handling/index.dart';
import 'package:tortiki/ui/bottom_navigation/bottom_navigation_controller.dart';
import 'package:tortiki/ui/reusable/widget_factory.dart';

class _MockErrorHandlingBloc extends MockBloc<ErrorHandlingState>
    implements ErrorHandlingBloc {}

class TestBottomNaigationControllerFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final errorHandlingBloc = _MockErrorHandlingBloc();

    return BlocProvider<ErrorHandlingBloc>(
        create: (context) => errorHandlingBloc,
        child: BottomNaigationController());
  }
}
