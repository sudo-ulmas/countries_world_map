import 'package:flutter/material.dart';
import '../components/canvas/touchy_canvas.dart';
import '../countries_world_map.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

/// This painter will paint a world map with all///
/// Giving countries a different color based on a data set can help visualize data.

class SimpleMapPainter extends CustomPainter {
  final List<Map<String, dynamic>> instructions;
  final double startLat, endLat, startLon, endLon;
  final List<String> coordinates;

  /// This Color is used for all the countries that have no custom color
  final Color defaultColor;
  final BuildContext context;

  /// The CountryColors is basically a list of Countries and Colors to give a Countrie a color of choice.
  final Map? colors;
  final void Function(String id, String name, TapUpDetails tapUpDetails)
      callback;

  final CountryBorder? countryBorder;

  const SimpleMapPainter({
    required this.instructions,
    required this.defaultColor,
    this.colors,
    required this.context,
    required this.callback,
    this.startLat = 0,
    this.startLon = 0,
    this.endLat = 0,
    this.endLon = 0,
    this.countryBorder,
    required this.coordinates,
  });

  @override
  void paint(Canvas c, Size s) {
    TouchyCanvas canvas = TouchyCanvas(context, c);

    // Get country paths from Json
    // List countryPaths = json.decode(jsonData);
    List<SimpleMapInstruction> countryPathList = <SimpleMapInstruction>[];
    for (var path in instructions) {
      if (!excludedCountries.contains(path['u'])) {
        countryPathList.add(SimpleMapInstruction.fromJson(path));
      }
    }

    // Draw paths
    for (int i = 0; i < countryPathList.length; i++) {
      List<String> paths = countryPathList[i].instructions;
      Path path = Path();
      if (countryPathList[i].name == 'Eriell' ||
          countryPathList[i].uniqueID == 'UZ-ER') {
        Paint paint = Paint()..color = Color(0xff1B3470);
        final String rawSvg = '''
M14,0 C21.732,0 28,5.641 28,12.6 C28,23.963 14,36 14,36 C14,36 0,24.064 0,12.6 C0,5.641 6.268,0 14,0 Z
''';
        for (var i = 0; i < coordinates.length; i += 1) {
          final latitude = double.parse(coordinates[i].split(',').first);
          final longitude = double.parse(coordinates[i].split(',').last);
          final relativeLat = (latitude - startLat) / (endLat - startLat);
          final relativeLon = (longitude - startLon) / (endLon - startLon);
          final Path complexPathToDraw = parseSvgPathData(rawSvg);
          path.addPath(complexPathToDraw, Offset.zero);
          c.save();
          c.translate(
            s.width * relativeLon,
            s.height * relativeLat,
          );
          c.scale(0.2);
          // c.translate(0, 0);
          c.drawPath(complexPathToDraw, paint);
          c.drawCircle(Offset(14, 14), 7, Paint()..color = Color(0xffE1B506));
          c.restore();
        }
      } else {
        for (int j = 0; j < paths.length; j++) {
          String instruction = paths[j];
          if (instruction == "c") {
            path.close();
          } else {
            List<String> coordinates = instruction.substring(1).split(',');
            double x = double.parse(coordinates[0]);
            double y = double.parse(coordinates[1]);

            if (instruction[0] == 'm') path.moveTo(s.width * x, s.height * y);
            if (instruction[0] == 'l') path.lineTo(s.width * x, s.height * y);
          }
        }

        final onTapUp = (tabdetail) => callback(
              countryPathList[i].uniqueID,
              countryPathList[i].name,
              tabdetail,
            );

        // Draw country body
        String uniqueID = countryPathList[i].uniqueID;
        Paint paint = Paint()..color = colors?[uniqueID] ?? defaultColor;
        canvas.drawPath(path, paint, onTapUp: onTapUp);

        // Draw country border
        if (countryBorder != null) {
          paint.color = countryBorder!.color;
          paint.strokeWidth = countryBorder!.width;
          paint.style = PaintingStyle.stroke;
          canvas.drawPath(path, paint, onTapUp: onTapUp);
        }
      }

      // Read path instructions and start drawing
    }
  }

  @override
  bool shouldRepaint(SimpleMapPainter oldDelegate) =>
      oldDelegate.colors != colors;
}

class SimpleMapInstruction {
  /// uniqueID of the territory being drawn
  String uniqueID;

  /// Name of the territory being drawn
  String name;

  /// List of instructions to draw the territory
  List<String> instructions;

  SimpleMapInstruction(
      {required this.uniqueID, required this.instructions, required this.name});

  // To Json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      "\"n\"": "\"$name\"",
      "\"u\"": "\"$uniqueID\"",
      "\"i\"": instructions,
    };
    return data;
  }

  // From Json
  factory SimpleMapInstruction.fromJson(Map<String, dynamic> json) {
    List<String> paths = <String>[];

    List jsonPaths = json['i'];

    for (int i = 0; i < jsonPaths.length; i++) {
      paths.add(jsonPaths[i]);
    }

    return SimpleMapInstruction(
        uniqueID: json['u'], name: json['n'], instructions: paths);
  }
}

final excludedCountries = [
  // Africa
  'dz', 'ao', 'bj', 'bw', 'bf', 'bi', 'cv', 'cm', 'cf', 'td', 'km', 'cd', 'cg',
  'dj', 'gq', 'er', 'sz', 'et', 'ga', 'gm', 'gh', 'gn', 'gw', 'ci', 'ke',
  'ls', 'lr', 'ly', 'mg', 'mw', 'ml', 'mr', 'mu', 'ma', 'mz', 'na', 'ne', 'ng',
  'rw', 'st', 'sn', 'sc', 'sl', 'so', 'za', 'ss', 'sd', 'tz', 'tg', 'tn', 'ug',
  'zm', 'zw',
  // North and South America
  'ar', 'bs', 'bb', 'bz', 'bo', 'br', 'ca', 'cl', 'co', 'cr', 'cu', 'do', 'ec',
  'sv', 'gt', 'gy', 'ht', 'hn', 'jm', 'mx', 'ni', 'pa', 'py', 'pe', 'sr', 'tt',
  'us', 'uy', 've',
  // Australia
  'au',
  // Oceania (Excluding Asia)
  'fj', 'ki', 'mh', 'fm', 'nr', 'pw', 'pg', 'ws', 'sb', 'to', 'tv', 'vu', 'tl',
  // Islands and territories (Excluding Europe and Asia)
  'ai', 'ag', 'aw', 'bs', 'bb', 'bq', 'ky', 'cw', 'dm', 'do', 'gd', 'gp', 'ht',
  'jm', 'ms', 'mq', 'bl', 'kn', 'lc', 'mf', 'vc', 'sx', 'tt', 'tc', 'vg', 'vi',
  'bm', 'io', 'fk', 'gf', 'tf', 'gi', 'gp', 'mq', 'yt', 'nc', 're', 'sh', 'pm',
  'wf',
  // Excluding specific territories
  'gl',
  'nz', 'eh', 'no', 'is', 'sj',
  "my", "id", "ph", "sg", "th", "vn", "bn", "tl", "fj", "pg", "ki", "mh", "fm",
  "ws", "sb",
];
