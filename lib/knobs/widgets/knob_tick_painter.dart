import 'dart:math';

import 'package:flutter/material.dart';
import 'package:knobwidget/knobs/enums/elements_position.dart';
import 'package:knobwidget/knobs/utils/major_tick_style.dart';
import 'package:knobwidget/knobs/utils/minor_tick_style.dart';

class KnobTickPainter extends CustomPainter {
  final double minimum;
  final double maximum;
  final double startAngle;
  final double endAngle;
  final bool showLabels;
  final MinorTickStyle minorTickStyle;
  final MajorTickStyle majorTickStyle;
  final ElementsPosition labelPosition;
  final int minorTicksPerInterval;
  final double tickOffset;
  final double labelOffset;
  final TextStyle? labelStyle;

  //
  final double current;
  final Paint tickPaint;

  KnobTickPainter({
    this.minimum = 0,
    this.maximum = 100,
    this.startAngle = 0,
    this.endAngle = 180,
    this.tickOffset = 0,
    this.labelOffset = 0,
    this.showLabels = true,
    this.majorTickStyle = const MajorTickStyle(),
    this.minorTickStyle = const MinorTickStyle(),
    this.labelPosition = ElementsPosition.outside,
    this.labelStyle,
    this.minorTicksPerInterval = 4,
    this.current = 0.0,
  }) : tickPaint = Paint() {
    tickPaint.strokeWidth = 1.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final radius = width / 2;
    // final radius = width * 0.7524;
    final soundCircleWidth = width * 0.0190 * 2;
    final innerCircleWidth = width * 0.0571;
    final spacedTicksLength = width * 0.0190 * 2;
    final spacedGreenSeparation = width * 0.0286 * 2;
    const spacedTicksWidth = 3.0;
    final sweepAngle = endAngle - startAngle;
    final range = maximum - minimum;
    final majorTickCount = sweepAngle ~/ range;
    final majorTickAngle = sweepAngle / majorTickCount;
    final minorTickCount = min(range / majorTickCount, minorTicksPerInterval);
    final minorTickAngle = majorTickAngle / minorTickCount;
    final totalTickCount = sweepAngle / minorTickAngle;
    double rotationAngle = minorTickAngle * pi / 180;

    paintGreenArc(canvas, size, innerCircleWidth + soundCircleWidth);

    //
    canvas.translate(size.width / 2, size.height / 2);
    canvas.save();
    //

    // canvas.rotate(3 * pi / 2);

    canvas.rotate(startAngle * pi / 180 - pi / 2);

    tickPaint.strokeWidth = minorTickStyle.thickness;
    // final tickLength = minorTickStyle.length;

    // for (int i = 0; i <= totalTickCount; i++) {
    //   print("current " + current.toString());
    //   print("getlabel " + _getLabel((i * minorTickAngle).toInt()).toString());
    //   bool isMajor = i % minorTickCount == 0;
    //   tickPaint.color = isMajor
    //       ? current >= _getLabel((i * minorTickAngle).toInt())
    //           ? majorTickStyle.highlightColor
    //           : majorTickStyle.color
    //       : current >= _getLabel((i * minorTickAngle).toInt())
    //           ? minorTickStyle.highlightColor
    //           : minorTickStyle.color;
    //   // tickPaint.strokeWidth =
    //   //     isMajor ? majorTickStyle.thickness : minorTickStyle.thickness;
    //   // final tickLength =
    //   //     (isMajor ? majorTickStyle.length : minorTickStyle.length);
    //   canvas.drawLine(
    //     Offset(0.0, -tickOffset - radius),
    //     Offset(0.0, -tickOffset - radius - tickLength),
    //     tickPaint,
    //   );
    //   canvas.rotate(rotationAngle);
    // }

    // CODIGO LEGADO DO KNOB WIDGET

    for (int i = 0; i <= totalTickCount; i++) {
      //DESENHAR OS TRAÇOS ESPAÇADOS
      tickPaint.strokeWidth = spacedTicksWidth;
      tickPaint.color = const Color(0xff393943);
      canvas.drawLine(
        Offset(
            0,
            -radius -
                soundCircleWidth -
                innerCircleWidth -
                spacedGreenSeparation), //ponto interno
        Offset(
            0,
            -radius -
                soundCircleWidth -
                innerCircleWidth -
                spacedGreenSeparation -
                spacedTicksLength), // ponto externo
        tickPaint,
      );

      //DESENHAR LINHA PRETA AO REDOR DO BOTAO PRINCIPAL (CONTROL KNOB)
      tickPaint.strokeWidth = 6;
      tickPaint.color = Colors.black;
      canvas.drawLine(
        Offset(0, -radius), //ponto interno
        // Offset(0, -tickOffset - radius - 5), // ponto externo
        Offset(0, -radius - innerCircleWidth),
        tickPaint,
      );

      // DESENHAR BARRA VERDE
      // if (current >= _getLabel((i * minorTickAngle).toInt())) {
      //   tickPaint.color = minorTickStyle.highlightColor;
      // } else {
      //   tickPaint.color = minorTickStyle.color;
      // }
      // canvas.drawLine(
      //   Offset(0, -radius - innerCircleWidth), //ponto interno
      //   Offset(
      //       0, -innerCircleWidth - radius - soundCircleWidth), // ponto externo
      //   tickPaint,
      // );

      canvas.rotate(rotationAngle);
    }

    canvas.restore();
  }

  //   0,
  // 0.15,
  // 0.25,  PONTOS DE STOPS PARA O GRADIENTE FICAR NO LUGAR CORRETO NA ATUALIZAÇÃO FUTURA, QUANDO FOR REMOVIDO O ROTATEBOX DO KNOBWIDGET
  // 0.25,
  // 0.85,
  // 0.99

  void paintGreenArc(Canvas canvas, Size size, double innerCircleWidth) {
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);
    final double radius = size.width / 2 + innerCircleWidth;

    Paint paint = Paint()
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 6.0
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..shader = const SweepGradient(colors: [
        Colors.green,
        Colors.yellow,
        Colors.red,
        Colors.red,
        Colors.green,
      ], stops: [
        0.1,
        0.15,
        0.35,
        0.5,
        0.5
      ], startAngle: 0, endAngle: 2 * pi)
          .createShader(Rect.fromCircle(center: center, radius: radius));
    drawArcWithRadius(canvas, center, radius, current * 3.6, paint);
  }

  double doubleToAngle(double angle) => angle * pi / 180.0;

  void drawArcWithRadius(
      Canvas canvas, Offset center, double radius, double angle, Paint paint) {
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi,
        doubleToAngle(angle), false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double _getLabel(int index) {
    return (maximum - minimum) / (endAngle - startAngle) * index + minimum;
  }
}
