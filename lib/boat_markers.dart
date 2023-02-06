import 'dart:convert';
import 'dart:io';

import 'package:bored_g/map_latlng.dart';
import '_file_paths.dart';
import '_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

const double _size = 8;
final Color _color = Colors.lime[800]!;
final Icon boatMarkerIcon = Icon(
  Icons.sailing_sharp,
  color: _color,
);

List<Marker> boatMarkers = (jsonDecode(File(cpDataPath).readAsStringSync())["boats"] as List<dynamic>).map(
  (e) {
    var boat = BoatLocation.fromJson(e);

    return Marker(
      point: LatLng(latFromNormY(boat.xy.y), lngFromNormX(boat.xy.x)),
      anchorPos: AnchorPos.align(AnchorAlign.center),
      width: _size,
      height: _size,
      builder: (context) => FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.contain,
        child: boatMarkerIcon,
      ),
    );
  },
).toList();
