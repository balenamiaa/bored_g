import 'package:flutter/widgets.dart';
// ignore: implementation_imports
import 'package:flutter_map/src/core/bounds.dart';
// ignore: implementation_imports
import 'package:flutter_map/src/map/flutter_map_state.dart';
import 'package:latlong2/latlong.dart';

class ScaledMarker {
  final LatLng center;
  final double widthLng;
  final double heightLat;

  final WidgetBuilder builder;
  final Key? key;

  final bool? rotate;
  final Offset? rotateOrigin;
  final AlignmentGeometry? rotateAlignment;

  ScaledMarker({
    required this.center,
    required this.widthLng,
    required this.heightLat,
    required this.builder,
    this.key,
    this.rotate,
    this.rotateOrigin,
    this.rotateAlignment,
  });
}

class ScaledMarkerLayer extends StatelessWidget {
  final List<ScaledMarker> markers;

  final bool rotate;
  final Offset? rotateOrigin;

  final AlignmentGeometry? rotateAlignment;

  const ScaledMarkerLayer(
      {super.key,
      this.markers = const [],
      this.rotate = false,
      this.rotateOrigin,
      this.rotateAlignment = Alignment.center});

  @override
  Widget build(BuildContext context) {
    final map = FlutterMapState.maybeOf(context)!;
    final markerWidgets = <Widget>[];

    for (final marker in markers) {
      final northwest = LatLng(marker.center.latitude + (marker.heightLat / 2),
          marker.center.longitude - (marker.widthLng / 2));
      final southeast = LatLng(marker.center.latitude - (marker.heightLat / 2),
          marker.center.longitude + (marker.widthLng / 2));

      final pxNorthWest = map.project(northwest);
      final pxSouthEast = map.project(southeast);

      final width = pxSouthEast.x - pxNorthWest.x;
      final height = pxSouthEast.y - pxNorthWest.y;

      if (!map.pixelBounds
          .containsPartialBounds(Bounds(pxNorthWest, pxSouthEast))) {
        continue;
      }

      if (width * height < 9) {
        continue;
      }

      final posNorthWest = pxNorthWest - map.pixelOrigin;
      final markerWidget = (marker.rotate ?? rotate)
          ? Transform.rotate(
              angle: -map.rotationRad,
              origin: marker.rotateOrigin ?? rotateOrigin,
              alignment: marker.rotateAlignment ?? rotateAlignment,
              child: marker.builder(context),
            )
          : marker.builder(context);

      markerWidgets.add(
        Positioned(
          key: marker.key,
          left: posNorthWest.x.toDouble(),
          top: posNorthWest.y.toDouble(),
          width: width.toDouble(),
          height: height.toDouble(),
          child: markerWidget,
        ),
      );
    }
    return Stack(
      children: markerWidgets,
    );
  }
}
