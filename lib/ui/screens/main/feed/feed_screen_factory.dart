import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/error_handling/index.dart';
import '../../../../bloc/feed/index.dart';
import '../../../reusable/widget_factory.dart';
import 'feed_screen.dart';

class FeedScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return BlocProvider(
        create: (context) => FeedBloc(
            errorHandlingBloc: BlocProvider.of<ErrorHandlingBloc>(context))
          ..add(BlocInit()),
        child: FeedScreen());
  }
}
