import 'dart:convert';
import 'dart:io';

import 'package:bored_g/map_latlng.dart';
import 'package:tuple/tuple.dart';
import '_file_paths.dart';
import '_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

List<Tuple2<String, Marker>> settlementLocationMarkers = (jsonDecode(File(cpDataPath).readAsStringSync())["locations"] as List<dynamic>).map(
  (e) {
    var location = Location.fromJson(e);

    return Tuple2(
      location.name,
      Marker(
        point: LatLng(latFromNormY(location.y), lngFromNormX(location.x)),
        builder: (context) => FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.none,
          child: Text(
            location.name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 12),
          ),
        ),
      ),
    );
  },
).toList();
