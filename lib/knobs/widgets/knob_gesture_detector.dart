import 'package:flutter/material.dart';
import 'package:knobwidget/knobs/controller/knob_controller.dart';
import 'package:knobwidget/knobs/utils/polar_coordinate.dart';
import 'package:knobwidget/knobs/widgets/control_knob.dart';
import 'package:knobwidget/knobs/widgets/radial_drag_gesture_detector.dart';
import 'package:provider/provider.dart';

class KnobGestureDetector extends StatefulWidget {
  const KnobGestureDetector({
    Key? key,
  }) : super(key: key);

  @override
  _KnobGestureDetectorState createState() => _KnobGestureDetectorState();
}

class _KnobGestureDetectorState extends State<KnobGestureDetector> {
  double initialValue = 0;
  bool canDrag = false;
  bool firstTime = true;
  int sensitivity = 8;

  void _onRadialDragStart(PolarCoordinate coordinate) {
    var controller = Provider.of<KnobController>(context, listen: false);
    var angle = coordinate.angle;
    var value = controller.getValueOfAngle(angle);

    if (firstTime) {
      initialValue = value;
      firstTime = false;
    } else {
      if ((initialValue >= value - sensitivity) &&
          (initialValue <= value + sensitivity)) {
        initialValue = value;
        canDrag = true;
      } else {
        canDrag = false;
      }
    }
  }

  void _onRadialDragUpdate(PolarCoordinate coordinate) {
    if (canDrag) {
      var controller = Provider.of<KnobController>(context, listen: false);
      var angle = coordinate.angle;
      var value = controller.getValueOfAngle(angle);

      if (value < 1) {
        if ((value >= initialValue - sensitivity) &&
            (value < initialValue + sensitivity)) {
          if (value < 0.5) value = 0;
          controller.setCurrentValue(value);
          initialValue = value;
        }
      } else {
        if (!((value > initialValue + sensitivity) ||
            (value < initialValue - sensitivity))) {
          if (value > 99.5) {
            value = 100.0;
          }
          controller.setCurrentValue(value);
          initialValue = value;
        }
      }
      print(
          "Drag: value $value angle: ${controller.getAngleOfValue(value)} /360 ${controller.getAngleOfValue(value) / 360}");
    }
  }

  void onRadialDragEnd() {
    // firstTime = true;
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<KnobController>(context);
    return RadialDragGestureDetector(
      onRadialDragStart: _onRadialDragStart,
      onRadialDragUpdate: _onRadialDragUpdate,
      onRadialDragEnd: onRadialDragEnd,
      child: ControlKnob(
        controller.getAngleOfValue(controller.value.current) / 360,
      ),
    );
  }
}
