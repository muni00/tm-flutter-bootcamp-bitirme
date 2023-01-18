import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bootcamp_bitirme_projesi/presentation/color/color_constant.dart';

class BackgroundPainter extends CustomPainter {
  BackgroundPainter({required Animation<double> animation})
      : curukPaint = Paint()
          ..color = ColorConstants.instance.acikTuruncu
          ..style = PaintingStyle.fill,
        lilaPaint = Paint()
          ..color = ColorConstants.instance.ortaKoyuTuruncu
          ..style = PaintingStyle.fill,
        pinkPaint = Paint()
          ..color = ColorConstants.instance.koyuTuruncu
          ..style = PaintingStyle.fill,
        liquidAnim = CurvedAnimation(
          curve: Curves.elasticOut,
          reverseCurve: Curves.easeInBack,
          parent: animation,
        ),
        pinkAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.7,
            curve: Interval(0, 0.8, curve: SpringCurve()),
          ),
          reverseCurve: Curves.linear,
        ),
        lilaAnim = CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0,
            0.8,
            curve: Interval(0, 0.9, curve: SpringCurve()),
          ),
          reverseCurve: Curves.easeInCirc,
        ),
        curukAnim = CurvedAnimation(
          parent: animation,
          curve: const SpringCurve(),
          reverseCurve: Curves.easeInCirc,
        ),
        super(repaint: animation);

  final Animation<double> liquidAnim;
  final Animation<double> curukAnim;
  final Animation<double> lilaAnim;
  final Animation<double> pinkAnim;

  final Paint curukPaint;
  final Paint lilaPaint;
  final Paint pinkPaint;

  @override
  void paint(Canvas canvas, Size size) {
    paintCuruk(canvas, size);
    paintLila(canvas, size);
    paintPink(canvas, size);
  }

  void paintCuruk(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(0, size.height, curukAnim.value)!,
    );
    _addPointsToPath(path, [
      Point(
        lerpDouble(0, size.width / 3, curukAnim.value)!,
        lerpDouble(0, size.height, curukAnim.value)!,
      ),
      Point(
        lerpDouble(size.width / 2, size.width / 4 * 3, liquidAnim.value)!,
        lerpDouble(size.height / 2, size.height / 4 * 3, liquidAnim.value)!,
      ),
      Point(
        size.width,
        lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value)!,
      ),
    ]);
    canvas.drawPath(path, curukPaint);
  }

  void paintLila(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width, 300);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.lineTo(
      0,
      lerpDouble(
        size.height / 4,
        size.height / 2,
        lilaAnim.value,
      )!,
    );
    _addPointsToPath(
      path,
      [
        Point(
          size.width / 4,
          lerpDouble(size.height / 2, size.height * 3 / 4, liquidAnim.value)!,
        ),
        Point(
          size.width * 3 / 5,
          lerpDouble(size.height / 4, size.height / 2, liquidAnim.value)!,
        ),
        Point(
          size.width * 4 / 5,
          lerpDouble(size.height / 6, size.height / 3, lilaAnim.value)!,
        ),
        Point(
          size.width,
          lerpDouble(size.height / 5, size.height / 4, lilaAnim.value)!,
        ),
      ],
    );
    canvas.drawPath(path, lilaPaint);
  }

  void paintPink(Canvas canvas, Size size) {
    if (pinkAnim.value > 0) {
      final path = Path();
      path.moveTo(size.width * 3 / 4, 0);
      path.lineTo(0, 0);
      path.lineTo(
        0,
        lerpDouble(
          0,
          size.height / 12,
          pinkAnim.value,
        )!,
      );
      _addPointsToPath(
        path,
        [
          Point(
            size.width / 7,
            lerpDouble(0, size.height / 6, liquidAnim.value)!,
          ),
          Point(
            size.width / 3,
            lerpDouble(0, size.height / 10, liquidAnim.value)!,
          ),
          Point(
            size.width / 3 * 2,
            lerpDouble(0, size.height / 8, liquidAnim.value)!,
          ),
          Point(
            size.width / 3 * 4,
            0,
          ),
        ],
      );
      canvas.drawPath(path, pinkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void _addPointsToPath(Path path, List<Point> points) {
    if (points.length < 3) {
      throw UnsupportedError("Need three or more to create a path");
    }

    for (var i = 0; i < points.length - 2; i++) {
      final xc = (points[i].x + points[i + 1].x) / 2;
      final yc = (points[i].y + points[i + 1].y) / 2;
      path.quadraticBezierTo(points[i].x, points[i].y, xc, yc);
    }

    // önceki iki noktayla bağlantı
    path.quadraticBezierTo(
        points[points.length - 2].x,
        points[points.length - 2].y,
        points[points.length - 1].x,
        points[points.length - 1].y);
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}

class SpringCurve extends Curve {
  const SpringCurve({
    this.a = 0.15,
    this.w = 19.4,
  });
  final double a;
  final double w;

  @override
  double transformInternal(double t) {
    return (-(pow(e, -t / a) * cos(t * w)) + 1).toDouble();
  }
}
