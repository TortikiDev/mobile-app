import 'dart:async';
import 'dart:math' as math;

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location/flutter_map_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:widget_factory/widget_factory.dart';

import '../../../bloc/map/index.dart';
import '../../../data/http_client/requests/requests.dart';
import '../../../data/http_client/responses/confectioner/confectioner_short_response.dart';
import '../../../data/http_client/responses/responses.dart';
import '../../../utils/string_is_valid_url.dart';
import '../../constants.dart';
import '../../reusable/image_views/avatar_size.dart';
import '../../reusable/show_dialog_mixin.dart';
import 'animated_map_controller.dart';
import 'confectioner_panel.dart';
import 'search_confectioners/search_confectioners_screen_factory.dart';

class MapScreen extends StatefulWidget {
  final WidgetFactory searchConfectionersScreenFactory;
  final WidgetFactory confectionerProfileScreenFactory;

  MapScreen({
    Key? key,
    required this.searchConfectionersScreenFactory,
    required this.confectionerProfileScreenFactory,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with
        AutomaticKeepAliveClientMixin<MapScreen>,
        TickerProviderStateMixin,
        ShowDialogMixin {
  late MapController _mapController;
  late AnimatedMapController _animatedMapController;
  StreamSubscription? _mapChangeSubscription;
  ConfectionerShortResponse? _selectedConfectioner;

  ValueNotifier<LocationServiceStatus>? _locationStatusNotifier;
  Function? _locationButtonPressed;

  late AnimationController _confectionerPanelAnimationController;
  late Animation<Offset> _confectionerPanelOffsetAnimation;

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
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _confectionerPanelAnimationController,
      curve: Curves.easeOutSine,
    ));
  }

  @override
  void dispose() {
    _mapChangeSubscription?.cancel();
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

      return Scaffold(
        body: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: Constants.defaultMapCenter,
                zoom: 12,
                minZoom: 12,
                plugins: [LocationPlugin()],
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(markers: confectionerMarkers),
                LocationOptions(
                  (context, status, onPressed) {
                    _locationStatusNotifier = status;
                    _locationButtonPressed = onPressed;
                    return Container();
                  },
                  markerBuilder: (context, latLongData, notifier) {
                    return Marker(
                      point: latLongData.location,
                      builder: (context) => Icon(
                        Icons.my_location,
                        color: theme.accentColor,
                      ),
                    );
                  },
                  onLocationRequested: (coord) {
                    if (coord != null) {
                      _animatedMapController.move(coord.location, 16.5);
                    }
                  },
                ),
              ],
            ),
            if (_locationStatusNotifier != null)
              Positioned(
                bottom: 16,
                right: 16,
                child: ValueListenableBuilder<LocationServiceStatus>(
                  valueListenable: _locationStatusNotifier!,
                  builder: (context, status, child) {
                    Icon buttonIcon;
                    switch (status) {
                      case LocationServiceStatus.subscribed:
                        buttonIcon = Icon(Icons.navigation);
                        break;
                      default:
                        buttonIcon = Icon(
                          Icons.navigation,
                          color: theme.colorScheme.onSurface,
                        );
                        break;
                    }

                    return FloatingActionButton(
                      onPressed: () {
                        if (_locationButtonPressed != null) {
                          _locationButtonPressed?.call();
                        } else if (status ==
                            LocationServiceStatus.permissionDenied) {
                          final localizations = AppLocalizations.of(context)!;
                          showTwoButtonsDialog(
                            context: context,
                            message: localizations.goToLocationSettingsMessage,
                            okButtonTitle: localizations.toSettings,
                            onOkPressed: () async =>
                                AppSettings.openLocationSettings(),
                          );
                        }
                      },
                      child: Transform.rotate(
                        angle: math.pi * 0.25,
                        child: buttonIcon,
                      ),
                    );
                  },
                ),
              ),
            Positioned(
              top: 8,
              left: 8,
              right: 8,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () =>
                      _searchConfectioners(context, mapCenter: state.mapCenter),
                  child: _MapSearchBar(),
                ),
              ),
            ),
            if (_selectedConfectioner != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SlideTransition(
                  position: _confectionerPanelOffsetAnimation,
                  child: Dismissible(
                    key: Key('Confectioner panel dismisible'),
                    direction: DismissDirection.down,
                    onDismissed: (direction) =>
                        _confectionerPanelAnimationController.reverse(),
                    child: ConfectionerPanel(
                      confectioner: _selectedConfectioner!,
                      confectionerProfileScreenFactory:
                          widget.confectionerProfileScreenFactory,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }

  List<Marker> _getConfectionerMarkers(
      List<ConfectionerShortResponse> confectioners, ThemeData theme) {
    if (_selectedConfectioner != null) {
      final selected = confectioners
          .firstWhere((element) => element.id == _selectedConfectioner?.id);
      confectioners.remove(selected);
      confectioners.add(selected);
    }

    return confectioners.map((conf) {
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
            child: Transform.rotate(
              angle: -_mapController.rotation / 60,
              child: CircleAvatar(
                key: ValueKey(isSelected),
                radius: markerSize,
                backgroundColor: borderColor,
                child: conf.avatarUrl?.isValidUrl() ?? false
                    ? CachedNetworkImage(
                        key: Key(conf.avatarUrl!),
                        imageUrl: conf.avatarUrl!,
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
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(photoRadius),
                        child: Container(
                          width: 2 * photoRadius,
                          height: 2 * photoRadius,
                          color: Colors.grey[300],
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            getPlaceholderAssetName(
                              size: AvatarSize.small,
                              male: conf.gender == Gender.male,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

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

  void _searchConfectioners(BuildContext context, {LatLong? mapCenter}) {
    if (mapCenter != null) {
      final screenData =
          SearchConfectionersScreenFactoryData(mapCenter: mapCenter);
      final route1 = PageRouteBuilder(
        pageBuilder: (c, a1, a2) => widget.searchConfectionersScreenFactory
            .createWidget(data: screenData),
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: Duration(milliseconds: 400),
        reverseTransitionDuration: Duration(milliseconds: 400),
      );
      Navigator.of(context).push(route1);
    }
  }
}

class _MapSearchBar extends StatelessWidget {
  const _MapSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 12),
          Icon(
            Icons.search,
            color: theme.colorScheme.onPrimary,
          ),
          SizedBox(width: 12),
          Text(
            localizations.searchConfectioner,
            style: theme.textTheme.subtitle1
                ?.copyWith(color: theme.colorScheme.onSurface),
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
