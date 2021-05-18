import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/external_confectioner_profile/index.dart';
import '../../../reusable/in_develop_screen_factory.dart';
import '../user_posts/user_posts_factory.dart';
import 'external_confectioner_profile_screen.dart';

class ExternalConfectionerProfileScreenFactoryData {
  final int confectionerId;
  final String confectionerName;

  ExternalConfectionerProfileScreenFactoryData({
    @required this.confectionerId,
    @required this.confectionerName,
  });
}

class ExternalConfectionerProfileScreenFactory
    implements WidgetFactory<ExternalConfectionerProfileScreenFactoryData> {
  @override
  Widget createWidget({ExternalConfectionerProfileScreenFactoryData data}) {
    final userPostsScreenFacory = UserPostsScreenFactory();
    final userRecipesScreenFacory = InDevelopWidgetFactory();

    return BlocProvider(
      create: (context) => ExternalConfectionerProfileBloc(
        confectionerId: data.confectionerId,
        confectionerName: data.confectionerName,
        confectionersRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: ExternalConfectionerProfileScreen(
        userPostsScreenFacory: userPostsScreenFacory,
        userRecipesScreenFacory: userRecipesScreenFacory,
      ),
    );
  }
}