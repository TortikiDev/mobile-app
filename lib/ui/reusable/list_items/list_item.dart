import 'package:equatable/equatable.dart';

abstract class ListItem implements Equatable {
  @override
  bool get stringify => true;
}