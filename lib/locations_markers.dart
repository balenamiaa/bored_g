import 'dart:convert';
import 'dart:io';

import 'package:bored_g/map_latlng.dart';
import 'package:bored_g/scaling_marker_layer.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:fluttericon/typicons_icons.dart';
import '_file_paths.dart';
import '_flutterstyle.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import 'types.dart';

abstract class LocationMarkerEntry {
  final String uiDisplayName;
  final WidgetBuilder builder;
  late Widget markerLayer;

  LocationMarkerEntry({
    required this.uiDisplayName,
    required this.builder,
  });
}

class FixedLocationMarkerEntry extends LocationMarkerEntry {
  final double size;
  final String nameInMapDataJson;
  final NormXY Function(dynamic e) locationRetriever;

  FixedLocationMarkerEntry({required super.uiDisplayName, required super.builder, required this.nameInMapDataJson, required this.size, required this.locationRetriever}) {
    markerLayer = MarkerLayer(
        markers: (jsonDecode(File(cpDataPath).readAsStringSync())[nameInMapDataJson] as List<dynamic>).map(
      (e) {
        var xy = locationRetriever(e);

        return Marker(point: LatLng(latFromNormY(xy.y), lngFromNormX(xy.x)), width: size, height: size, builder: builder);
      },
    ).toList());
  }
}

class ScaledLocationMarkerEntry extends LocationMarkerEntry {
  final double widthLng;
  final double heightLat;
  final String nameInMapDataJson;
  final NormXY Function(dynamic e) locationRetriever;

  ScaledLocationMarkerEntry({required super.uiDisplayName, required super.builder, required this.nameInMapDataJson, required this.widthLng, required this.heightLat, required this.locationRetriever}) {
    markerLayer = ScaledMarkerLayer(
        markers: (jsonDecode(File(cpDataPath).readAsStringSync())[nameInMapDataJson] as List<dynamic>).map(
      (e) {
        var xy = locationRetriever(e);

        return ScaledMarker(center: LatLng(latFromNormY(xy.y), lngFromNormX(xy.x)), widthLng: widthLng, heightLat: heightLat, builder: builder);
      },
    ).toList());
  }
}

var locationMarkers = <LocationMarkerEntry>[
  FixedLocationMarkerEntry(
    uiDisplayName: "Boat",
    nameInMapDataJson: "boats",
    locationRetriever: (e) => BoatLocation.fromJson(e).xy,
    size: 6,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.sailing_sharp,
        color: Colors.lightGreen[400]!,
      ),
    ),
  ),
  FixedLocationMarkerEntry(
    uiDisplayName: "Well Pump",
    nameInMapDataJson: "well_pumps",
    locationRetriever: (e) => WellPumpLocation.fromJson(e).xy,
    size: 12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.water,
        color: Colors.blueAccent[100]!,
      ),
    ),
  ),
  FixedLocationMarkerEntry(
    uiDisplayName: "Light House",
    nameInMapDataJson: "lighthouses",
    locationRetriever: (e) => LightHouseLocation.fromJson(e).xy,
    size: 12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.lighthouse,
        color: Colors.yellow[300]!,
      ),
    ),
  ),
  FixedLocationMarkerEntry(
    uiDisplayName: "Church",
    nameInMapDataJson: "churchs",
    locationRetriever: (e) => ChurchLocation.fromJson(e).xy,
    size: 12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.church,
        color: Colors.blueGrey[100]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Military Tent",
    nameInMapDataJson: "military_tents",
    locationRetriever: (e) => MilitaryTentLocation.fromJson(e).xy,
    widthLng: 0.32,
    heightLat: 0.16,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.crossed_sabres,
        color: Colors.amber[900]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Military Barrack",
    nameInMapDataJson: "military_barracks",
    locationRetriever: (e) => MilitaryBarrackLocation.fromJson(e).xy,
    widthLng: 0.32,
    heightLat: 0.16,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.crossed_sabres,
        color: Colors.amber[800]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Caravan Wreck",
    nameInMapDataJson: "caravan_wrecks",
    locationRetriever: (e) => CaravanWreckLocation.fromJson(e).xy,
    widthLng: 0.28,
    heightLat: 0.14,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.directions_transit_filled_sharp,
        color: Colors.blueAccent[700]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Bus",
    nameInMapDataJson: "ikarus_wrecks",
    locationRetriever: (e) => IkarusWreckLocation.fromJson(e).xy,
    widthLng: 0.32,
    heightLat: 0.16,
    builder: (context) => const FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.bus_alert_sharp,
        color: Color.fromARGB(255, 80, 41, 255),
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Truck",
    nameInMapDataJson: "truck_wrecks",
    locationRetriever: (e) => TruckWreckLocation.fromJson(e).xy,
    widthLng: 0.32,
    heightLat: 0.16,
    builder: (context) => const FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.fire_truck_sharp,
        color: Color.fromARGB(255, 80, 41, 255),
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Sedan Wreck",
    nameInMapDataJson: "sedan_wrecks",
    locationRetriever: (e) => SedanWreckLocation.fromJson(e).xy,
    widthLng: 0.24,
    heightLat: 0.12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.car_crash_sharp,
        color: Colors.blueAccent[700]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Hb Wreck",
    nameInMapDataJson: "hb_wrecks",
    locationRetriever: (e) => HbWreckLocation.fromJson(e).xy,
    widthLng: 0.24,
    heightLat: 0.12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.car_crash_sharp,
        color: Colors.blueAccent[700]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Deer Stand",
    nameInMapDataJson: "deerstands",
    locationRetriever: (e) => DeerStandLocation.fromJson(e).xy,
    widthLng: 0.18,
    heightLat: 0.9,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.tower,
        color: Colors.deepOrange[500]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Green House",
    nameInMapDataJson: "greenhouses",
    locationRetriever: (e) => GreenHouseLocation.fromJson(e).xy,
    widthLng: 0.20,
    heightLat: 0.10,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.carrot,
        color: Colors.greenAccent[200]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Grocery Kiosk",
    nameInMapDataJson: "grocery_kiosks",
    locationRetriever: (e) => GreenHouseLocation.fromJson(e).xy,
    widthLng: 0.24,
    heightLat: 0.12,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        Icons.storefront_sharp,
        color: Colors.greenAccent[200]!,
      ),
    ),
  ),
  ScaledLocationMarkerEntry(
    uiDisplayName: "Barn",
    nameInMapDataJson: "barns",
    locationRetriever: (e) => GreenHouseLocation.fromJson(e).xy,
    widthLng: 0.36,
    heightLat: 0.18,
    builder: (context) => FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.contain,
      child: Icon(
        RpgAwesome.grass,
        color: Colors.yellowAccent[700]!,
      ),
    ),
  ),
];
