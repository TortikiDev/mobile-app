import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../../bloc/map/index.dart';
import '../../../data/http_client/responses/confectioner_short_response.dart';
import '../../../utils/string_is_valid_url.dart';
import 'animated_map_controller.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin<MapScreen>, TickerProviderStateMixin {
  MapController _mapController;
  AnimatedMapController _animatedMapController;
  StreamSubscription _mapChangeSubscription;
  ConfectionerShortResponse _selectedConfectioner;

  AnimationController _confectionerPanelAnimationController;
  Animation<Offset> _confectionerPanelOffsetAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _animatedMapController = AnimatedMapController(
      mapController: _mapController,
      duration: Duration(seconds: 1),
      tickerProvider: this,
    );

    _mapChangeSubscription = _mapController.mapEventStream
        .where((event) => event.source != MapEventSource.mapController)
        .listen((event) {
      if (_confectionerPanelAnimationController.status ==
          AnimationStatus.completed) {
        _confectionerPanelAnimationController.reverse();
      }
      if (event.source == MapEventSource.dragEnd) {
        final mapCenter = event.center;
        BlocProvider.of<MapBloc>(context).add(UpdateMapCenter(mapCenter));
      }
    });

    _confectionerPanelAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _confectionerPanelAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _selectedConfectioner = null;
        });
      }
    });
    _confectionerPanelOffsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.0),
      end: Offset(0.0, -1.2),
    ).animate(CurvedAnimation(
      parent: _confectionerPanelAnimationController,
      curve: Curves.easeOutSine,
    ));
  }

  @override
  void dispose() {
    _mapChangeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return BlocBuilder<MapBloc, MapState>(buildWhen: (previous, current) {
      return previous.confectioners != current.confectioners;
    }, builder: (context, state) {
      final confectionerMarkers =
          _getConfectionerMarkers(state.confectioners, theme);

      return Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              // TODO: use actual user's coordinates
              center: LatLng(54.602, 39.862),
              zoom: 16.5,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(
                markers: confectionerMarkers,
              ),
            ],
          ),
          if (_selectedConfectioner != null)
            Positioned(
              bottom: -64,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _confectionerPanelOffsetAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Dismissible(
                    key: Key('Confectioner panel dismisible'),
                    direction: DismissDirection.down,
                    onDismissed: (direction) =>
                        _confectionerPanelAnimationController.reverse(),
                    child: _ConfectionerPanel(
                      confectioner: _selectedConfectioner,
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }

  List<Marker> _getConfectionerMarkers(
          List<ConfectionerShortResponse> confectioners, ThemeData theme) =>
      confectioners
          .map(
            (conf) => Marker(
              width: 48,
              height: 48,
              point: LatLng(conf.coordinate.lat, conf.coordinate.long),
              builder: (context) => GestureDetector(
                onTap: () => _tapOnConfectionerMarker(conf),
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryVariant,
                  child: conf.avatarUrl?.isValidUrl() ?? false
                      ? CachedNetworkImage(
                          key: Key(conf.avatarUrl),
                          imageUrl: conf.avatarUrl,
                          imageBuilder: (context, imageProvider) {
                            return CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.transparent,
                                backgroundImage: imageProvider);
                          },
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.grey[300]),
                ),
              ),
            ),
          )
          .toList();

  void _tapOnConfectionerMarker(ConfectionerShortResponse confectioner) {
    setState(() {
      _selectedConfectioner = confectioner;
    });
    _confectionerPanelAnimationController.forward();
    final newMapCenter = LatLng(
      confectioner.coordinate.lat,
      confectioner.coordinate.long,
    );
    _animatedMapController.move(newMapCenter);
  }
}

class _ConfectionerPanel extends StatelessWidget {
  final ConfectionerShortResponse confectioner;
  const _ConfectionerPanel({
    Key key,
    @required this.confectioner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
      ),
      child: Center(
        child: Text(confectioner.name),
      ),
    );
  }
}
