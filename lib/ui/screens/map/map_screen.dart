import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import '../../../bloc/map/index.dart';

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

    return FlutterMap(
      options: MapOptions(
        center: LatLng(54.602, 39.862),
        zoom: 16.5,
        controller: _mapController,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
      ],
    );
  }
}
