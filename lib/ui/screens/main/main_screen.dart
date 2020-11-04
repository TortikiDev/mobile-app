import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/main/index.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add scaffold body
    return BlocBuilder<MainBloc, MainState>(
        builder: (context, state) => Scaffold());
  }
}