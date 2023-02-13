import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

import '_flutterstyle.dart';
import '_cp_data.dart';
import 'locations/pink_location_markers.dart';
import 'locations/red_location_markers.dart';
import 'locations/settlement_location_markers.dart';
import 'ui/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  hotKeyManager.unregisterAll();

  await loadCpData();
  loadSettlementLocationMarkers();
  loadPinkLocationMarkers();
  loadRedLocationMarkers();

  runApp(const ProviderScope(child: DayZAppRoot()));
}
