import 'package:flutter/material.dart';
import 'dart:math';

import 'package:knobwidget/knobs/controller/knob_controller.dart';
import 'package:knobwidget/knobs/knob_widget.dart';
import 'package:knobwidget/knobs/utils/control_style.dart';
import 'package:knobwidget/knobs/utils/knob_style.dart';
import 'package:knobwidget/knobs/utils/pointer_style.dart';

class KnobPage extends StatefulWidget {
  const KnobPage({Key? key}) : super(key: key);

  @override
  State<KnobPage> createState() => _KnobPageState();
}

class _KnobPageState extends State<KnobPage> {
  final double _minimum = 0;
  final double _maximum = 100;

  late KnobController _controller;
  late double _knobValue;

  void valueChangedListener(double value) {
    if (mounted) {
      setState(() {
        _knobValue = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _knobValue = _minimum;
    _controller = KnobController(
      initial: _knobValue,
      minimum: _minimum,
      maximum: _maximum,
      startAngle: 0,
      endAngle: 360,
    );
    _controller.addOnValueChangedListener(valueChangedListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("widget.title"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(_knobValue.toString()),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                var value =
                    Random().nextDouble() * (_maximum - _minimum) + _minimum;
                _controller.setCurrentValue(value);
              },
              child: const Text('Update Knob Value'),
            ),
            const SizedBox(height: 75),
            Container(
              child: Knob(
                  controller: _controller,
                  width: 150,
                  height: 150,
                  style: KnobStyle(
                      showLabels: false,
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      tickOffset: 5,
                      labelOffset: 10,
                      minorTicksPerInterval: 34,
                      pointerStyle: const PointerStyle(color: Colors.white),
                      controlStyle: const ControlStyle(
                          backgroundColor: Colors.black,
                          glowColor: Colors.black,
                          shadowColor: Colors.black))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeOnValueChangedListener(valueChangedListener);
    super.dispose();
  }
}
