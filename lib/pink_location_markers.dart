import 'dart:convert';
import 'dart:io';

import 'package:bored_g/map_latlng.dart';
import '_file_paths.dart';
import '_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

const double _hospitalSize = 12;
final Color _hospitalColor = Colors.pink[400]!;
final Icon hospitalIcon = Icon(
  Icons.local_hospital_sharp,
  color: _hospitalColor,
);

const double _medicalCenterSize = 12;
final Color _medicalCenterColor = Colors.pink[800]!;
final Icon medicalCenterIcon = Icon(
  Icons.medical_services_sharp,
  color: _medicalCenterColor,
);

List<Marker> pinkLocationMarkers = (jsonDecode(File(cpDataPath).readAsStringSync())["pink_locations"] as List<dynamic>).map(
  (e) {
    var pinkLocation = PinkLocation.fromJson(e);

    if (pinkLocation.type == PinkLocationType.hospital) {
      return Marker(
        point: LatLng(latFromNormY(pinkLocation.xy.y), lngFromNormX(pinkLocation.xy.x)),
        anchorPos: AnchorPos.align(AnchorAlign.center),
        width: _hospitalSize,
        height: _hospitalSize,
        builder: (context) => FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.contain,
          child: hospitalIcon,
        ),
      );
    } else if (pinkLocation.type == PinkLocationType.medicalcenter) {
      return Marker(
        point: LatLng(latFromNormY(pinkLocation.xy.y), lngFromNormX(pinkLocation.xy.x)),
        anchorPos: AnchorPos.align(AnchorAlign.center),
        width: _medicalCenterSize,
        height: _medicalCenterSize,
        builder: (context) => FittedBox(
          alignment: Alignment.center,
          fit: BoxFit.contain,
          child: medicalCenterIcon,
        ),
      );
    }

    return Marker(point: LatLng(latFromNormY(pinkLocation.xy.y), lngFromNormX(pinkLocation.xy.x)), builder: (cx) => const Icon(Icons.dangerous));
  },
).toList();
