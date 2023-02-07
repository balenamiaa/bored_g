import 'dart:ffi' hide Size;
import 'dart:io';

import 'package:bored_g/locations_markers.dart';
import 'package:bored_g/pink_location_markers.dart';
import 'package:bored_g/red_location_markers.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:latlong2/latlong.dart';
import 'package:win32/win32.dart' hide Polygon;
import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as path;

import '_file_paths.dart';
import 'crosshair_painter.dart';
import 'settlement_location_markers.dart';
import 'map_latlng.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hotKeyManager.unregisterAll();

  runApp(const DayZAppRoot());
}

class DayZAppRoot extends StatelessWidget {
  const DayZAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayZ Tools',
      darkTheme: ThemeData(primarySwatch: Colors.amber, colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: FractionallySizedBox(widthFactor: 1.0, heightFactor: 1.0, child: DayZApp()),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      ),
    );
  }
}

class DayZApp extends StatefulWidget {
  const DayZApp({super.key});

  @override
  State<StatefulWidget> createState() => DayZAppState();
}

class DayZAppState extends State<DayZApp> {
  final Alignment _enabledMapAlignment = Alignment.lerp(Alignment.centerLeft, Alignment.center, 0.625)!;
  final Alignment _disabledMapAlignment = Alignment.bottomRight;

  bool isEnabled = false;
  double _mapWidth = 256;
  double _mapHeight = 256;
  bool _imageOverlayEnabled = false;
  List<bool> locationMarkersEnabled = List.filled(locationMarkers.length, true);
  bool _redLocationsEnabled = true;
  bool _pinkLocationsEnabled = true;
  late MapController _mapController;

  HotKey openToolHotkey = HotKey(KeyCode.home, modifiers: [KeyModifier.control]);
  final int _hwnd = FindWindow("FLUTTER_RUNNER_WIN32_WINDOW".toNativeUtf16(), nullptr);

  @override
  void dispose() {
    super.dispose();
    hotKeyManager.unregister(openToolHotkey);
  }

  @override
  void initState() {
    super.initState();
    hotKeyManager.register(
      openToolHotkey,
      keyDownHandler: openToolHotkeyDownHandler,
    );

    _mapController = MapController();
  }

  void openToolHotkeyDownHandler(HotKey hotkey) {
    setState(() {
      isEnabled = !isEnabled;

      if (isEnabled) {
        _mapWidth = 1024;
        _mapHeight = 900;

        SetWindowLongPtr(_hwnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TOPMOST);
      } else {
        _mapWidth = 256;
        _mapHeight = 256;

        SetWindowLongPtr(_hwnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TRANSPARENT | WS_EX_TOPMOST);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mapWidget = createMap();

    var ui = Column(
      children: [
        CheckboxMenuButton(
          value: _imageOverlayEnabled,
          onChanged: (value) {
            setState(() {
              _imageOverlayEnabled = value ?? false;
            });
          },
          child: const Text("Loot Overlay"),
        ),
        ...locationMarkers.mapIndexed(
          (index, e) => CheckboxMenuButton(
            value: locationMarkersEnabled[index],
            onChanged: (value) {
              setState(() {
                locationMarkersEnabled[index] = value ?? false;
              });
            },
            child: Row(
              children: [Text(e.uiDisplayName), const SizedBox(width: 8), e.builder(context)],
            ),
          ),
        ),
        CheckboxMenuButton(
          value: _redLocationsEnabled,
          onChanged: (value) {
            setState(() {
              _redLocationsEnabled = value ?? false;
            });
          },
          child: Row(
            children: [const Text("Red Locations"), const SizedBox(width: 8), policeStationIcon, const SizedBox(width: 8), fireStationIcon],
          ),
        ),
        CheckboxMenuButton(
          value: _pinkLocationsEnabled,
          onChanged: (value) {
            setState(() {
              _pinkLocationsEnabled = value ?? false;
            });
          },
          child: Row(
            children: [const Text("Pink Locations"), const SizedBox(width: 8), hospitalIcon, const SizedBox(width: 8), medicalCenterIcon],
          ),
        ),
      ],
    );

    var mapAndUi = Row(
      children: [
        Visibility(
          visible: isEnabled,
          child: Expanded(
            flex: 2,
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ui,
                  ),
                )),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(alignment: isEnabled ? _enabledMapAlignment : _disabledMapAlignment, child: mapWidget),
        ),
      ],
    );

    var crosshairAndMapUi = CustomPaint(painter: DayZCrosshairPainter(!isEnabled), child: mapAndUi);

    return crosshairAndMapUi;
  }

  Widget createMap() {
    return SizedBox(
      width: _mapWidth,
      height: _mapHeight,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
          color: const Color.fromARGB(225, 62, 8, 8),
          width: 2,
        )),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onTap: (tapPosition, point) => print(point),
            interactiveFlags: InteractiveFlag.drag | InteractiveFlag.flingAnimation,
            crs: DayZCrs(),
            zoom: 2,
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
              opacity: 1.0,
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
                markers: settlementLocationMarkers,
                builder: (context, markers) {
                  return Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.amber[400]),
                    child: Center(
                      child: Text(
                        markers.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 6,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_imageOverlayEnabled)
              OverlayImageLayer(
                overlayImages: [
                  OverlayImage(
                    opacity: 0.15,
                    bounds: LatLngBounds(
                      LatLng(-90, -180.0),
                      LatLng(90.0, 180.0),
                    ),
                    imageProvider: FileImage(File(lootTierPath)),
                  ),
                ],
              ),
            ...locationMarkers.mapIndexed((index, e) => locationMarkersEnabled[index] ? e.markerLayer : null).whereNotNull()
          ],
        ),
      ),
    );
  }
}
