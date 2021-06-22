import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/user_posts/index.dart';
import 'user_posts_screen.dart';

class UserPostsScreenFactoryData {
  final bool isMyPosts;
  final int userId;

  UserPostsScreenFactoryData({required this.isMyPosts, required this.userId});
}

class UserPostsScreenFactory
    implements WidgetFactory<UserPostsScreenFactoryData> {
  @override
  Widget createWidget({UserPostsScreenFactoryData? data}) {
    return BlocProvider(
      create: (context) => UserPostsBloc(
        isMyPosts: data!.isMyPosts,
        userId: data.userId,
        postsRepository: RepositoryProvider.of(context),
        errorHandlingBloc: BlocProvider.of(context),
      )..add(BlocInit()),
      child: UserPostsScreen(),
    );
  }
}
