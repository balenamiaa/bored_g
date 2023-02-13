import 'package:bored_g/map_latlng.dart';
import 'package:tuple/tuple.dart';
import '../_cp_data.dart';
import '../_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

late List<Tuple3<String, String, Marker>> settlementLocationMarkers;

void loadSettlementLocationMarkers() {
  settlementLocationMarkers = cpData["locations"]!.map(
    (e) {
      var location = Location.fromJson(e);

      return Tuple3(
        location.name,
        location.russianName,
        Marker(
          point: LatLng(latFromNormY(location.y), lngFromNormX(location.x)),
          builder: (context) => Column(
            children: [
              Flexible(
                child: FittedBox(
                    alignment: Alignment.center,
                    fit: BoxFit.none,
                    child: Text(
                      location.russianName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12),
                    )),
              ),
              SizedBox.fromSize(
                size: const Size(0, 4),
              ),
              FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.none,
                  child: Text(
                    location.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 8),
                  )),
            ],
          ),
        ),
      );
    },
  ).toList();
}
