import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final int _hwnd =
    FindWindow("FLUTTER_RUNNER_WIN32_WINDOW".toNativeUtf16(), nullptr);
int? _oldHwnd;

void stealFocus() {
  _oldHwnd = GetForegroundWindow();
  SetWindowLongPtr(_hwnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TOPMOST);
  SetForegroundWindow(_hwnd);
  SetFocus(_hwnd);
}

void returnFocus() {
  SetWindowLongPtr(
      _hwnd, GWL_EXSTYLE, WS_EX_LAYERED | WS_EX_TRANSPARENT | WS_EX_TOPMOST);
  if (_oldHwnd != null) {
    SetForegroundWindow(_oldHwnd!);
    SetFocus(_oldHwnd!);
  }
}
