import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../../bloc/create_recipe/index.dart';
import '../../../../bloc/error_handling/index.dart';
import '../../../../data/repositories/repositories.dart';
import 'create_recipe_screen.dart';

class CreateRecipeScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    return Builder(
      builder: (context) {
        final recipesRepository =
            RepositoryProvider.of<RecipesRepository>(context);
        final errorHandlingBloc = BlocProvider.of<ErrorHandlingBloc>(context);
        final createRecipeBloc = CreateRecipeBloc(
          recipesRepository: recipesRepository,
          errorHandlingBloc: errorHandlingBloc,
        )..add(BlocInit());
        final imagePicker = ImagePicker();
        return BlocProvider(
          create: (context) => createRecipeBloc,
          child: CreateRecipeScreen(imagePicker: imagePicker),
        );
      },
    );
  }
}
