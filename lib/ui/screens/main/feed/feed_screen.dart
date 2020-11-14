import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/feed/index.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add scaffold body
    return BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) => Scaffold());
  }
}