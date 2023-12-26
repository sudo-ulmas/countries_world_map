import 'package:flutter/material.dart';
import '../components/canvas/touchy_canvas.dart';
import '../countries_world_map.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:touchable/touchable.dart' as t;

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
  final void Function({
    required bool isIconTargeted,
    required double lat,
    required double lon,
    required String cityId,
  }) hitTestCallback;

  final CountryBorder? countryBorder;
  final double zoom;

  SimpleMapPainter({
    required this.instructions,
    required this.defaultColor,
    required this.hitTestCallback,
    this.colors,
    required this.context,
    required this.callback,
    this.startLat = 0,
    this.startLon = 0,
    this.endLat = 0,
    this.endLon = 0,
    this.countryBorder,
    required this.zoom,
    required this.coordinates,
  });
  List<(Path path, double lat, double lon, String cityId)> iconPaths = [];

  @override
  void paint(Canvas c, Size s) {
    TouchyCanvas canvas = TouchyCanvas(context, c);
    t.TouchyCanvas myCanvas = t.TouchyCanvas(context, c);
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
      if (countryPathList[i].name.contains('Eriell')) {
        Paint paint = Paint()..color = Color(0xff1B3470);
        final String rawSvg = '''
M2.8,0 C4.3464,0 5.6,1.1282 5.6,2.52 C5.6,4.7926 2.8,7.2 2.8,7.2 C2.8,7.2 0,4.8128 0,2.52 C0,1.1282 1.2536,0 2.8,0 Z
''';
//         final String rawSvg = '''
// M14,0 C21.732,0 28,5.641 28,12.6 C28,23.963 14,36 14,36 C14,36 0,24.064 0,12.6 C0,5.641 6.268,0 14,0 Z
// ''';
        //     final String rawSvg = '''
        //   M${1 / zoom * 14},0 C${1 / zoom * 21.732},0 ${1 / zoom * 28},5.641 ${1 / zoom * 28},${1 / zoom * 12.6} C${1 / zoom * 28},${1 / zoom * 23.963} ${1 / zoom * 14},${1 / zoom * 36} ${1 / zoom * 14},${1 / zoom * 36} C${1 / zoom * 14},${1 / zoom * 36} ${1 / zoom * 0},${1 / zoom * 24.064} ${1 / zoom * 0},${1 / zoom * 12.6} C${1 / zoom * 0},${1 / zoom * 5.641} ${1 / zoom * 6.268},0 ${1 / zoom * 14},0 Z
        // ''';

        final latitude = double.parse(
            coordinates[int.parse(countryPathList[i].uniqueID)]
                .split(',')
                .first);
        final longitude = double.parse(
            coordinates[int.parse(countryPathList[i].uniqueID)]
                .split(',')
                .last);
        final relativeLat = (latitude - startLat) / (endLat - startLat);
        final relativeLon = (longitude - startLon) / (endLon - startLon);
        final Path complexPathToDraw = parseSvgPathData(rawSvg);
        path.addPath(
            complexPathToDraw,
            Offset(
              s.width * relativeLon,
              s.height * relativeLat,
            ));
        iconPaths.add((
          path,
          relativeLat,
          relativeLon,
          countryPathList[i].name.split(' ').last,
        ));
        // path.addPath(complexPathToDraw, Offset.zero);
        c.save();
        c.translate(
          s.width * relativeLon,
          s.height * relativeLat,
        );
        // c.scale(0.2);
        // c.translate(0, 0);
        myCanvas.drawPath(complexPathToDraw, paint);
        myCanvas.drawCircle(
          Offset(2.8, 2.8),
          1.4,
          Paint()..color = Color(0xffE1B506),
        );
        c.restore();
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
  bool? hitTest(Offset position) {
    if (iconPaths.isNotEmpty) {
      var contains = false;
      (Path, double, double, String) path =
          (iconPaths.first.$1, 0, 0, iconPaths.first.$4);
      for (var iconPath in iconPaths) {
        contains = iconPath.$1.contains(position);
        path = (iconPath.$1, iconPath.$2, iconPath.$3, iconPath.$4);
        if (contains) break;
      }

      hitTestCallback(
        isIconTargeted: contains,
        lat: path.$3,
        lon: path.$2,
        cityId: path.$4,
      );
    }
    return false;
  }

  @override
  bool shouldRepaint(SimpleMapPainter oldDelegate) =>
      true; //  oldDelegate.colors != colors;
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
