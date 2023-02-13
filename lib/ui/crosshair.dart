import 'package:bored_g/globals.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../_flutterstyle.dart';
import '../crosshair_painter.dart';

class DayZCrosshair extends ConsumerWidget {
  const DayZCrosshair({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var crosshairEnabledRef = ref.watch(crosshairEnabled);
    return CustomPaint(
        painter: DayZCrosshairPainter(crosshairEnabledRef),
        size: Size.infinite);
  }
}
