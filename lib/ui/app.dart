import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../app_localizations.dart';
import '../bloc/error_handling/index.dart';
import 'app_theme.dart';
import 'bottom_navigation/bottom_navigation_controller.dart';
import 'reusable/show_dialog_mixin.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tortiki',
        theme: appTheme,
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ru'),
        ],
        home: _ErrorHandlingDecorator(child: BottomNaigationController()));
  }
}

class _ErrorHandlingDecorator extends StatelessWidget with ShowDialogMixin {
  final Widget child;
  const _ErrorHandlingDecorator({Key key, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ErrorHandlingBloc(),
        child: BlocListener<ErrorHandlingBloc, ErrorHandlingState>(
            listenWhen: (previous, current) => current is ShowDialog,
            listener: (context, state) {
              void dismissError() => BlocProvider.of<ErrorHandlingBloc>(context)
                  .add(DismissErrorDialog());

              if (state is ShowDialog) {
                showErrorDialog(
                    context: context,
                    errorMessage: state.message,
                    onOkPressed: dismissError,
                    onDismiss: dismissError);
              }
            },
            child: child));
  }
}
