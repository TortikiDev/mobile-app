import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../bloc/map/index.dart';
import '../../../data/http_client/responses/confectioner_short_response.dart';
import '../../../utils/string_is_valid_url.dart';
import '../../reusable/buttons/secondary_button.dart';
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
              bottom: -128,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _confectionerPanelOffsetAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
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
      confectioners.map((conf) {
        final isSelected = _selectedConfectioner?.id == conf.id;
        final markerSize = isSelected ? 64.0 : 48.0;
        final photoRadius = (markerSize * 0.5) - (isSelected ? 5.0 : 3.0);
        final borderColor = isSelected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.primaryVariant;

        return Marker(
          width: markerSize,
          height: markerSize,
          point: LatLng(conf.coordinate.lat, conf.coordinate.long),
          builder: (context) {
            return GestureDetector(
              onTap: () => _tapOnConfectionerMarker(conf),
              child: CircleAvatar(
                key: ValueKey(isSelected),
                radius: markerSize,
                backgroundColor: borderColor,
                child: conf.avatarUrl?.isValidUrl() ?? false
                    ? CachedNetworkImage(
                        key: Key(conf.avatarUrl),
                        imageUrl: conf.avatarUrl,
                        imageBuilder: (context, imageProvider) {
                          return CircleAvatar(
                            key: ValueKey(isSelected),
                            radius: photoRadius,
                            backgroundColor: Colors.transparent,
                            backgroundImage: imageProvider,
                          );
                        },
                        fit: BoxFit.cover,
                      )
                    : Container(color: Colors.grey[300]),
              ),
            );
          },
        );
      }).toList();

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
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Container(
      height: 128,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.grey[300],
              ),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: confectioner.avatarUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2),
                AutoSizeText(
                  confectioner.name,
                  style: theme.textTheme.subtitle1,
                  maxLines: 1,
                  minFontSize: 10,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  confectioner.address,
                  style: theme.textTheme.caption
                      .copyWith(color: theme.colorScheme.onSurface),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (confectioner.starType !=
                        ConfectionerRatingStarType.none)
                      Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: _getRatignStarColor(confectioner.starType),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        confectioner.rating.toString(),
                        style: theme.textTheme.subtitle2
                            .copyWith(color: theme.colorScheme.onPrimary),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Spacer(),
                SizedBox(
                  height: 24,
                  child: Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: localizations.profile,
                          onPressed: () => _goToProfile(context),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SecondaryButton(
                          text: localizations.route,
                          onPressed: () => _buildRoute(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatignStarColor(int ratingStarType) {
    switch (ratingStarType) {
      case ConfectionerRatingStarType.bronze:
        return Colors.brown[400];
      case ConfectionerRatingStarType.silver:
        return Colors.grey[300];
      case ConfectionerRatingStarType.gold:
        return Colors.yellow[600];
      default:
        return Colors.transparent;
    }
  }

  void _goToProfile(BuildContext context) {
    // TODO: implement _goToProfile
  }

  void _buildRoute(BuildContext context) {
    // TODO: implement _buildRoute
  }
}
