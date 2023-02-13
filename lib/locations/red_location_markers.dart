import 'package:bored_g/_cp_data.dart';
import 'package:bored_g/map_latlng.dart';
import '../_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

const double _policeStationSize = 12;
final Color _policeStationColor = Colors.red[500]!;
final Icon policeStationIcon = Icon(
  Icons.local_police_sharp,
  color: _policeStationColor,
);

const double _fireStationSize = 12;
final Color _fireStationColor = Colors.red[500]!;
final Icon fireStationIcon = Icon(
  Icons.local_fire_department_sharp,
  color: _fireStationColor,
);

late List<Marker> redLocationMarkers;

void loadRedLocationMarkers() {
  redLocationMarkers = cpData["red_locations"]!.map(
    (e) {
      var redLocation = RedLocation.fromJson(e);

      if (redLocation.type == RedLocationType.policestation) {
        return Marker(
          point: LatLng(
              latFromNormY(redLocation.xy.y), lngFromNormX(redLocation.xy.x)),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          width: _policeStationSize,
          height: _policeStationSize,
          builder: (context) => FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.contain,
            child: policeStationIcon,
          ),
        );
      } else if (redLocation.type == RedLocationType.firestation) {
        return Marker(
          point: LatLng(
              latFromNormY(redLocation.xy.y), lngFromNormX(redLocation.xy.x)),
          anchorPos: AnchorPos.align(AnchorAlign.center),
          width: _fireStationSize,
          height: _fireStationSize,
          builder: (context) => FittedBox(
            alignment: Alignment.center,
            fit: BoxFit.contain,
            child: fireStationIcon,
          ),
        );
      }

      return Marker(
          point: LatLng(
              latFromNormY(redLocation.xy.y), lngFromNormX(redLocation.xy.x)),
          builder: (cx) => const Icon(Icons.dangerous));
    },
  ).toList();
}
