import 'package:bored_g/globals.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../locations/locations_markers.dart';
import '../locations/pink_location_markers.dart';
import '../locations/red_location_markers.dart';
import 'map_search.dart';

class DayZUI extends ConsumerWidget {
  const DayZUI({super.key});

  CheckboxMenuButton createCheckbox(bool value,
      {required Function(bool?) onChanged, required List<Widget> children}) {
    return CheckboxMenuButton(
      value: value,
      onChanged: onChanged,
      child: Row(
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isAppEnabled = ref.watch(appEnabled);
    var redLocationsEnabledRef = ref.watch(redLocationsEnabled);
    var pinkLocationsEnabledRef = ref.watch(pinkLocationsEnabled);
    var locationMarkersEnabledRef = ref.watch(locationMarkersEnabled);
    var imageOverlayEnabledRef = ref.watch(imageOverlayEnabled);
    var crosshairEnabledRef = ref.watch(crosshairEnabled);
    var minimapEnabledRef = ref.watch(minimapEnabled);

    var uiWidgets = <Widget>[
      IconButton(
        onPressed: () => showSearchDialog(context),
        icon: const Icon(Icons.search),
        splashRadius: 24,
      ),
      const SizedBox(height: 24),
      ...locationMarkers.mapIndexed(
        (i, x) {
          return createCheckbox(
            locationMarkersEnabledRef[i],
            onChanged: (value) =>
                ref.read(locationMarkersEnabled.notifier).set(i, value!),
            children: [
              Text(x.uiDisplayName),
              const SizedBox(width: 8),
              x.builder(context)
            ],
          );
        },
      ),
      createCheckbox(
        redLocationsEnabledRef,
        onChanged: (x) => ref.read(redLocationsEnabled.notifier).state = x!,
        children: [
          const Text("Red Locations"),
          const SizedBox(width: 8),
          policeStationIcon,
          const SizedBox(width: 8),
          fireStationIcon
        ],
      ),
      createCheckbox(
        pinkLocationsEnabledRef,
        onChanged: (x) => ref.read(pinkLocationsEnabled.notifier).state = x!,
        children: [
          const Text("Pink Locations"),
          const SizedBox(width: 8),
          hospitalIcon,
          const SizedBox(width: 8),
          medicalCenterIcon
        ],
      ),
      const SizedBox(height: 12),
      createCheckbox(
        imageOverlayEnabledRef,
        onChanged: (x) => ref.read(imageOverlayEnabled.notifier).state = x!,
        children: const [Text("Loot Overlay")],
      ),
      createCheckbox(
        crosshairEnabledRef,
        onChanged: (x) => ref.read(crosshairEnabled.notifier).state = x!,
        children: const [Text("Crosshair")],
      ),
      createCheckbox(
        minimapEnabledRef,
        onChanged: (x) => ref.read(minimapEnabled.notifier).state = x!,
        children: const [Text("Minimap")],
      ),
    ];

    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      heightFactor: 1.0,
      widthFactor: 0.15,
      child: Visibility(
        visible: isAppEnabled,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Card(
            color: const Color.fromARGB(255, 27, 7, 2),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemBuilder: (context, index) => uiWidgets[index],
                itemCount: uiWidgets.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
