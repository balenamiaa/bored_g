import 'package:collection/collection.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '_flutterstyle.dart';
import 'locations/locations_markers.dart';

final appEnabled = StateProvider((ref) => false);
final escKeyLastHeldDown = StateProvider((ref) => false);
final minimapEnabled = StateProvider((ref) => true);
final crosshairEnabled = StateProvider((ref) => true);
final imageOverlayEnabled = StateProvider((ref) => false);
final redLocationsEnabled = StateProvider((ref) => true);
final pinkLocationsEnabled = StateProvider((ref) => true);
final locationMarkersEnabled =
    StateNotifierProvider<LocationMarkersEnabledNotifier, List<bool>>(
        (ref) => LocationMarkersEnabledNotifier());
final mapController = MapController();

const Alignment enabledMapAlignment = Alignment.center;
const Alignment disabledMapAlignment = Alignment.topRight;

const enabledMapSize = Tuple2(1400.0, 1000.0);
const disabledMapSize = Tuple2(360.0, 360.0);

const enabledOpacity = 1.0;
const disabledOpacity = 0.9;

final HotKey enableAppHotkey =
    HotKey(KeyCode.home, modifiers: [KeyModifier.control]);
final HotKey moveMapUpHotkey =
    HotKey(KeyCode.arrowUp, modifiers: [KeyModifier.shift]);
final HotKey moveMapDownHotkey =
    HotKey(KeyCode.arrowDown, modifiers: [KeyModifier.shift]);
final HotKey moveMapLeftHotkey =
    HotKey(KeyCode.arrowLeft, modifiers: [KeyModifier.shift]);
final HotKey moveMapRightHotkey =
    HotKey(KeyCode.arrowRight, modifiers: [KeyModifier.shift]);

final HotKey mapZoomInHotkey =
    HotKey(KeyCode.pageUp, modifiers: [KeyModifier.shift]);
final HotKey mapZoomOutHotkey =
    HotKey(KeyCode.pageDown, modifiers: [KeyModifier.shift]);

// all the paths are relative to the current working directory
const String cpDataPath = "chernarusplus_data/cpdata.json";
const String offlineMapRootPath = "offlineMap/";
const lootTierPath = "offlineMap/loot_tiers.png";

class LocationMarkersEnabledNotifier extends StateNotifier<List<bool>> {
  LocationMarkersEnabledNotifier()
      : super(List.filled(locationMarkers.length, true));

  void set(int index, bool value) {
    state =
        state.mapIndexed((i, element) => i == index ? value : element).toList();
  }
}
