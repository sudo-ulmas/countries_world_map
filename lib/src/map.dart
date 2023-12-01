import 'package:flutter/material.dart';
import 'dart:convert';

import '../components/canvas/touch_detector.dart';

import 'painter.dart';

/// This is the main widget that will paint the map based on the given insturctions (json).
class SimpleMap extends StatelessWidget {
  final String instructions;

  final CountryBorder? countryBorder;

  /// Default color for all countries. If not provided the default Color will be grey.
  final Color? defaultColor;

  /// This is basically a list of countries and colors to apply different colors to specific countries.
  final Map? colors;

  /// Triggered when a country is tapped.
  /// The first parameter is the isoCode of the country that was tapped.
  /// The second parameter is the TapUpDetails of the tap.
  final void Function(String id, String name, TapUpDetails tapDetails)?
      callback;

  /// This is the BoxFit that will be used to fit the map in the available space.
  /// If not provided the default BoxFit will be BoxFit.contain.
  final BoxFit? fit;

  const SimpleMap({
    required this.instructions,
    this.defaultColor,
    this.colors,
    this.callback,
    this.fit,
    this.countryBorder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map map = jsonDecode(instructions);

    double width = double.parse(map['w'].toString());
    double height = double.parse(map['h'].toString());
    List<Map<String, dynamic>> instruction =
        List<Map<String, dynamic>>.from(map['i']);

    return FittedBox(
      fit: fit ?? BoxFit.contain,
      child: RepaintBoundary(
          child: CanvasTouchDetector(
              builder: (context) => CustomPaint(
                    isComplex: true,
                    size: Size(width, height),
                    painter: SimpleMapPainter(
                        context: context,
                        instructions: instruction,
                        callback: (id, name, tapdetails) {
                          if (countriesOfInterest.contains(id)) {
                            if (callback != null) {
                              print('$id $name $tapdetails');
                              callback!(id, name, tapdetails);
                            }
                          }
                        },
                        countryBorder: countryBorder,
                        colors: colors,
                        defaultColor: defaultColor ?? Colors.grey),
                  ))),
    );
  }
}

class CountryBorder {
  final Color color;
  final double width;

  const CountryBorder({
    required this.color,
    this.width = 1,
  });
}

final countriesOfInterest = [
  'at',
  'bd',
  'cn',
  'cy',
  'cz',
  'cn',
  'ae',
  'nl',
  'uz'
];
