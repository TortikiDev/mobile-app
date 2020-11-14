import 'package:flutter/widgets.dart';

import 'post_view_model.dart';

class PostView extends StatelessWidget {
  final PostViewModel model;

  const PostView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(''),
    );
  }
}
