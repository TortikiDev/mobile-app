import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/external_confectioner_profile/index.dart';
import '../user_posts/user_posts_factory.dart';
import '../user_recipes.dart/user_recipes_screen_factory.dart';
import 'external_confectioner_profile_screen.dart';

class ExternalConfectionerProfileScreenFactoryData {
  final int confectionerId;
  final String confectionerName;
  final int confectionerGender;

  ExternalConfectionerProfileScreenFactoryData({
    @required this.confectionerId,
    @required this.confectionerName,
    @required this.confectionerGender,
  });
}

class ExternalConfectionerProfileScreenFactory
    implements WidgetFactory<ExternalConfectionerProfileScreenFactoryData> {
  @override
  Widget createWidget({ExternalConfectionerProfileScreenFactoryData data}) {
    final userPostsScreenFacory = UserPostsScreenFactory();
    final userRecipesScreenFacory = UserRecipesScreenFactory();

    return BlocProvider(
      create: (context) => ExternalConfectionerProfileBloc(
        confectionerId: data.confectionerId,
        confectionerName: data.confectionerName,
        confectionerGender: data.confectionerGender,
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
