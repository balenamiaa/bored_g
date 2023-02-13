import 'package:bored_g/ui/crosshair.dart';
import 'package:bored_g/ui/map.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:latlong2/latlong.dart';

import '../_flutterstyle.dart';
import '../globals.dart';
import '../platform_tools.dart'
    if (dart.library.io) '../platform_tools_win.dart';
import 'dayz_ui.dart';
import 'map_search.dart';

class DayZAppRoot extends StatelessWidget {
  const DayZAppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayZ Tools',
      darkTheme: ThemeData(
          primarySwatch: Colors.amber, colorScheme: const ColorScheme.dark()),
      themeMode: ThemeMode.dark,
      home: const Scaffold(
        body: DayZApp(),
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      ),
    );
  }
}

class DayZApp extends ConsumerStatefulWidget {
  const DayZApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => DayZAppState();
}

class DayZAppState extends ConsumerState<DayZApp> {
  final FocusNode focus = FocusNode();

  @override
  void dispose() {
    super.dispose();
    hotKeyManager.unregister(enableAppHotkey);
    hotKeyManager.unregister(enableAppHotkey);
    hotKeyManager.unregister(moveMapUpHotkey);
    hotKeyManager.unregister(moveMapDownHotkey);
    hotKeyManager.unregister(moveMapLeftHotkey);
    hotKeyManager.unregister(moveMapRightHotkey);
    hotKeyManager.unregister(mapZoomInHotkey);
    hotKeyManager.unregister(mapZoomOutHotkey);
  }

  @override
  void initState() {
    super.initState();
    hotKeyManager.register(enableAppHotkey,
        keyDownHandler: toggleDayZAppOverlay);
    hotKeyManager.register(moveMapUpHotkey,
        keyDownHandler: moveMapToUpHotkeyDownHandler);
    hotKeyManager.register(moveMapDownHotkey,
        keyDownHandler: moveMapToDownHotkeyDownHandler);
    hotKeyManager.register(moveMapLeftHotkey,
        keyDownHandler: moveMapToLeftHotkeyDownHandler);
    hotKeyManager.register(moveMapRightHotkey,
        keyDownHandler: moveMapToRightHotkeyDownHandler);
    hotKeyManager.register(mapZoomInHotkey,
        keyDownHandler: mapZoomInHotkeyDownHandler);
    hotKeyManager.register(mapZoomOutHotkey,
        keyDownHandler: mapZoomOutHotkeyDownHandler);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(appEnabled, (prev, next) {
      if (next) {
        var notifier = ref.read(escKeyLastHeldDown.notifier);
        notifier.state = false;
        stealFocus();
      } else {
        Navigator.of(context).popUntil((x) => x.isFirst);
        returnFocus();
      }
    });

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
            SearchLocationsIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): QuitOverlayIntent(),
      },
      child: Actions(
        dispatcher: const ActionDispatcher(),
        actions: <Type, Action<Intent>>{
          SearchLocationsIntent:
              SearchLocationsAction(() => showSearchDialog(context)),
          QuitOverlayIntent: QuitOverlayAction(ref),
        },
        child: Focus(
          autofocus: true,
          focusNode: focus,
          onKey: (e, key) {
            if (!key.isKeyPressed(LogicalKeyboardKey.escape) &&
                ref.read(escKeyLastHeldDown)) {
              var notifier = ref.read(appEnabled.notifier);
              notifier.state = !notifier.state;
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: const FractionallySizedBox(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: Stack(
              children: [DayZCrosshair(), DayZMap(), DayZUI()],
            ),
          ),
        ),
      ),
    );
  }

  void toggleDayZAppOverlay(HotKey hotKey) {
    var notifier = ref.read(appEnabled.notifier);
    notifier.state = !notifier.state;
  }

  void moveMapToUpHotkeyDownHandler(HotKey hotkey) {
    mapController.move(
      LatLng(mapController.center.latitude + 1, mapController.center.longitude),
      mapController.zoom,
    );
  }

  void moveMapToDownHotkeyDownHandler(HotKey hotkey) {
    mapController.move(
      LatLng(mapController.center.latitude - 1, mapController.center.longitude),
      mapController.zoom,
    );
  }

  void moveMapToLeftHotkeyDownHandler(HotKey hotkey) {
    mapController.move(
      LatLng(mapController.center.latitude, mapController.center.longitude - 1),
      mapController.zoom,
    );
  }

  void moveMapToRightHotkeyDownHandler(HotKey hotkey) {
    mapController.move(
      LatLng(mapController.center.latitude, mapController.center.longitude + 1),
      mapController.zoom,
    );
  }

  void mapZoomInHotkeyDownHandler(HotKey hotkey) {
    mapController.move(mapController.center, mapController.zoom + 0.5);
  }

  void mapZoomOutHotkeyDownHandler(HotKey hotkey) {
    mapController.move(mapController.center, mapController.zoom - 0.5);
  }
}

class SearchLocationsIntent extends Intent {}

class QuitOverlayIntent extends Intent {}

class SearchLocationsAction extends Action<SearchLocationsIntent> {
  final Function() showDialog;
  SearchLocationsAction(this.showDialog);

  @override
  void invoke(SearchLocationsIntent intent) {
    showDialog();
  }
}

class QuitOverlayAction extends Action<QuitOverlayIntent> {
  final WidgetRef ref;

  QuitOverlayAction(this.ref);

  @override
  void invoke(QuitOverlayIntent intent) {
    var notifier = ref.read(escKeyLastHeldDown.notifier);
    notifier.state = true;
  }
}
