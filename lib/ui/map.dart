import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:path/path.dart' as path;

import '../_flutterstyle.dart';
import '../globals.dart';
import '../locations/locations_markers.dart';
import '../locations/pink_location_markers.dart';
import '../locations/red_location_markers.dart';
import '../locations/settlement_location_markers.dart';
import '../map_latlng.dart';

class DayZMap extends ConsumerWidget {
  const DayZMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isAppEnabled = ref.watch(appEnabled);
    var minimapEnabledRef = ref.watch(minimapEnabled);
    var locationMarkersEnabledRef = ref.watch(locationMarkersEnabled);
    var imageOverlayEnabledRef = ref.watch(imageOverlayEnabled);
    var redLocationsEnabledRef = ref.watch(redLocationsEnabled);
    var pinkLocationsEnabledRef = ref.watch(pinkLocationsEnabled);

    return Visibility(
      visible: isAppEnabled || minimapEnabledRef,
      child: Container(
        alignment: isAppEnabled ? enabledMapAlignment : disabledMapAlignment,
        child: SizedBox(
          width: isAppEnabled ? enabledMapSize.item1 : disabledMapSize.item1,
          height: isAppEnabled ? enabledMapSize.item2 : disabledMapSize.item2,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(225, 62, 8, 8),
                width: 2,
              ),
            ),
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                interactiveFlags:
                    InteractiveFlag.drag | InteractiveFlag.flingAnimation,
                crs: DayZCrs(),
                zoom: 2.5,
                maxBounds: LatLngBounds(
                  LatLng(-90, -180.0),
                  LatLng(90.0, 180.0),
                ),
                center: LatLng(0, 0),
              ),
              children: [
                TileLayer(
                  tileProvider: FileTileProvider(),
                  urlTemplate: path.join(offlineMapRootPath, "{z}/{x}/{y}.jpg"),
                  maxNativeZoom: 7,
                  opacity: isAppEnabled ? enabledOpacity : disabledOpacity,
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 72,
                    size: const Size(12, 12),
                    anchor: AnchorPos.align(AnchorAlign.center),
                    fitBoundsOptions: const FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                      maxZoom: 15,
                    ),
                    markers:
                        settlementLocationMarkers.map((e) => e.item3).toList(),
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.amber[400]),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (imageOverlayEnabledRef)
                  OverlayImageLayer(
                    overlayImages: [
                      OverlayImage(
                        opacity: 0.15,
                        bounds: LatLngBounds(
                          LatLng(-90, -180.0),
                          LatLng(90.0, 180.0),
                        ),
                        imageProvider: const AssetImage(lootTierPath),
                      ),
                    ],
                  ),
                ...locationMarkers
                    .mapIndexed((index, e) =>
                        locationMarkersEnabledRef[index] ? e.markerLayer : null)
                    .whereNotNull(),
                if (redLocationsEnabledRef)
                  MarkerLayer(markers: redLocationMarkers),
                if (pinkLocationsEnabledRef)
                  MarkerLayer(markers: pinkLocationMarkers)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
