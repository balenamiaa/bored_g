import 'dart:convert';
import 'dart:io';

import 'package:bored_g/map_latlng.dart';
import '_file_paths.dart';
import '_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

const double _size = 12;
final Color _color = Colors.blueAccent[100]!;
final Icon wellPumpMarkerIcon = Icon(
  Icons.water,
  color: _color,
);

List<Marker> wellPumpMarkers = (jsonDecode(File(cpDataPath).readAsStringSync())["well_pumps"] as List<dynamic>).map(
  (e) {
    var wellpump = WellPumpLocation.fromJson(e);

    return Marker(
      point: LatLng(latFromNormY(wellpump.xy.y), lngFromNormX(wellpump.xy.x)),
      anchorPos: AnchorPos.align(AnchorAlign.center),
      width: 12,
      height: 12,
      builder: (context) => FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.contain,
        child: wellPumpMarkerIcon,
      ),
    );
  },
).toList();
