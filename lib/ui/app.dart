import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../app_localizations.dart';
import '../bloc/error_handling/index.dart';
import '../data/database/db_factory.dart';
import '../data/http_client/http_client_factory.dart';
import '../data/repositories/repositories.dart';
import 'app_theme.dart';
import 'bottom_navigation/bottom_navigation_controller.dart';
import 'reusable/show_dialog_mixin.dart';
import 'screens/splash_screen.dart';

class App extends StatelessWidget {
  final HttpClientFactory httpClientFactory;
  final DbFactory dbFactory;

  const App({
    Key key,
    @required this.httpClientFactory,
    @required this.dbFactory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ErrorHandlingDecorator(
      child: MaterialApp(
        title: 'Tortiki',
        theme: appTheme,
        localizationsDelegates: [
          const AppLocalizationsDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('ru'),
        ],
        home: FutureBuilder(
          future: dbFactory.createDb(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MultiProvider(
                providers: [
                  Provider(
                      create: (context) =>
                          httpClientFactory.createHttpClient()),
                  Provider<Database>(create: (context) => snapshot.data),
                ],
                child: RepositoryProvider(
                  create: (context) => BookmarkedRecipesRepository(
                    db: Provider.of<Database>(context, listen: false),
                  ),
                  child: BottomNaigationController(),
                ),
              );
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
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
