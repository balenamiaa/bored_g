import '_flutterstyle.dart';

class DayZCrosshairPainter extends CustomPainter {
  final bool isEnabled;

  DayZCrosshairPainter(this.isEnabled);

  @override
  void paint(Canvas canvas, Size size) {
    if (!isEnabled) return;

    var paint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var center = Offset(size.width / 2, size.height / 2);

    canvas.drawLine(
        center + const Offset(-10, 0), center + const Offset(-5, 0), paint);

    canvas.drawLine(
        center + const Offset(5, 0), center + const Offset(10, 0), paint);

    canvas.drawLine(
        center + const Offset(0, 5), center + const Offset(0, 10), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
