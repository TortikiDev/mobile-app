import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../../bloc/map/index.dart';
import '../../../data/http_client/responses/confectioner_short_response.dart';
import '../../../utils/string_is_valid_url.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with AutomaticKeepAliveClientMixin<MapScreen> {
  final _mapController = MapController();
  StreamSubscription _mapChangeSubscription;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _mapChangeSubscription = _mapController.mapEventStream.listen((event) {
      final mapCenter = event.center;
      BlocProvider.of<MapBloc>(context).add(UpdateMapCenter(mapCenter));
    });
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

      return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          // TODO: use actual user's coordinates
          center: LatLng(54.602, 39.862),
          zoom: 16.5,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: confectionerMarkers,
          ),
        ],
      );
    });
  }

  List<Marker> _getConfectionerMarkers(
          List<ConfectionerShortResponse> confectioners, ThemeData theme) =>
      confectioners
          .map(
            (e) => Marker(
              width: 48,
              height: 48,
              point: LatLng(e.coordinate.lat, e.coordinate.long),
              builder: (context) => CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primaryVariant,
                child: e.avatarUrl?.isValidUrl() ?? false
                    ? CachedNetworkImage(
                        key: Key(e.avatarUrl),
                        imageUrl: e.avatarUrl,
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
          )
          .toList();
}
