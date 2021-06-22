import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../utils/iterable_safe_element_at.dart';

class ImagesCollection extends StatefulWidget {
  final List<String> _urls;
  const ImagesCollection({Key? key, required List<String> urls})
      : _urls = urls,
        super(key: key);

  @override
  _ImagesCollectionState createState() => _ImagesCollectionState();
}

class _ImagesCollectionState extends State<ImagesCollection> {
  int _currentpage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urls = widget._urls;
    return Stack(
      children: [
        Positioned.fill(
          child: PageView.builder(
            physics: ClampingScrollPhysics(),
            itemCount: urls.length,
            itemBuilder: (context, index) {
              final imageUrl = urls.safeElementAt(index);
              return imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey);
            },
            onPageChanged: (page) {
              setState(() {
                _currentpage = page;
              });
            },
          ),
        ),
        if (urls.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: _DotsIndicator(
              itemCount: urls.length,
              theme: theme,
              selectedItem: _currentpage,
            ),
          ),
      ],
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int itemCount;
  final ThemeData theme;
  final int selectedItem;

  _DotsIndicator({
    Key? key,
    required this.itemCount,
    required this.theme,
    this.selectedItem = 0,
  })  : assert(selectedItem < itemCount),
        super(key: key);

  Widget _buildDot(int index) {
    return Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color:
              index == selectedItem ? theme.colorScheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
