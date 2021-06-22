import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tortiki/bloc/create_recipe/index.dart';
import 'package:widget_factory/widget_factory.dart';
import 'package:tortiki/ui/screens/main/create_recipe/create_recipe_screen.dart';

class _MockCreateRecipeBloc extends Mock implements CreateRecipeBloc {}

class _MockImagePicker extends Mock implements ImagePicker {}

class TestCreateRecipeScreenFactory implements WidgetFactory {
  @override
  Widget createWidget({dynamic data}) {
    final createRecipeBloc = _MockCreateRecipeBloc();
    final createRecipeInitialState = CreateRecipeState.initial();
    when(() => createRecipeBloc.state).thenReturn(createRecipeInitialState);
    when(() => createRecipeBloc.stream).thenAnswer((realInvocation) =>
        Stream<CreateRecipeState>.value(createRecipeInitialState));

    final imagePicker = _MockImagePicker();

    return BlocProvider<CreateRecipeBloc>(
      create: (context) => createRecipeBloc,
      child: CreateRecipeScreen(imagePicker: imagePicker),
    );
  }
}
