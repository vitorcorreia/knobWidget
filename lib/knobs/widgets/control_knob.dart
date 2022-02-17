// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:knobwidget/knobs/utils/knob_style.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ControlKnob extends StatelessWidget {
  final double rotation;

  const ControlKnob(
    this.rotation, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Provider.of<KnobStyle>(context);
    return Transform(
      transform: Matrix4.rotationZ(2 * pi * rotation),
      alignment: Alignment.center,
      child: Material(
        elevation: 10,
        shape: const CircleBorder(),
        //     shadowColor: style.controlStyle.shadowColor,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
                Color(0xff393943),
                Color(0xff1C1D26),
              ],
            ),
            //   color: style.controlStyle.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: <Widget>[
              // Container(
              //   width: double.infinity,
              //   height: double.infinity,
              //   decoration: const BoxDecoration(shape: BoxShape.circle),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: CustomPaint(
              //       painter: AllTickPainter(
              //         tickCount: style.controlStyle.tickStyle.count,
              //         margin: style.controlStyle.tickStyle.margin,
              //         width: style.controlStyle.tickStyle.width,
              //         color: style.controlStyle.tickStyle.color,
              //       ),
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(style.pointerStyle.offset),
                  child: Container(
                    height: style.pointerStyle.height,
                    width: style.pointerStyle.width,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: style.pointerStyle.color,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
