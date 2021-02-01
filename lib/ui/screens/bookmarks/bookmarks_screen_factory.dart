import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/bookmarks/index.dart';
import '../../../bloc/error_handling/index.dart';
import '../../reusable/widget_factory.dart';
import 'bookmarks_screen.dart';

class BookmarksScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => BookmarksBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context),)
          ..add(BlocInit()),
        child: BookmarksScreen(),);
  }
}
