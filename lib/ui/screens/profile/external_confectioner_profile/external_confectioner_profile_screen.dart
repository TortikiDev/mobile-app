import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/external_confectioner_profile/index.dart';

class ExternalConfectionerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: add scaffold body
    return BlocBuilder<ExternalConfectionerProfileBloc,
            ExternalConfectionerProfileState>(
        builder: (context, state) => Scaffold());
  }
}
