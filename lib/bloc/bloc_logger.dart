import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocLogger extends BlocObserver {
  static const _tag = "BlocLogger";

  @override
  void onEvent(Bloc bloc, Object event) {
    debugPrint(
        "[$_tag event ${DateTime.now().toString()}] ${event.toString()}");
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint("[$_tag transition ${DateTime.now().toString()}]"
        " ${transition.toString()}");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    debugPrint(
        "[$_tag error ${DateTime.now().toString()}] ${error.toString()}");
    super.onError(cubit, error, stackTrace);
  }
}
