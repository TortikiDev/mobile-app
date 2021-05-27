import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tortiki/bloc/external_confectioner_profile/index.dart';
import 'package:tortiki/ui/screens/profile/external_confectioner_profile/external_confectioner_profile_screen.dart';
import 'package:tortiki/ui/screens/profile/external_confectioner_profile/external_confectioner_profile_screen_factory.dart';

import 'package:widget_factory/widget_factory.dart';

class _MockExternalConfectionerProfileBloc
    extends MockBloc<ExternalConfectionerProfileState>
    implements ExternalConfectionerProfileBloc {}

class _MockScreenFactory extends Mock implements WidgetFactory {}

class TestExternalConfectionerProfileScreenFactory
    implements WidgetFactory<ExternalConfectionerProfileScreenFactoryData> {
  @override
  Widget createWidget({ExternalConfectionerProfileScreenFactoryData data}) {
    final recipeDetailsBloc = _MockExternalConfectionerProfileBloc();
    final recipeDetailsState = ExternalConfectionerProfileState.initial(
      confectionerName: data.confectionerName,
      confectionerId: data.confectionerId,
      confectionerGender: data.confectionerGender,
    );
    when(recipeDetailsBloc.state).thenReturn(recipeDetailsState);
    whenListen(recipeDetailsBloc,
        Stream<ExternalConfectionerProfileState>.value(recipeDetailsState));

    final userPostsScreenFacory = _MockScreenFactory();
    final userRecipesScreenFacory = _MockScreenFactory();

    return BlocProvider<ExternalConfectionerProfileBloc>(
      create: (context) => recipeDetailsBloc,
      child: ExternalConfectionerProfileScreen(
        userPostsScreenFacory: userPostsScreenFacory,
        userRecipesScreenFacory: userRecipesScreenFacory,
      ),
    );
  }
}
