import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:side_sheet/side_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InteractiveMap(),
    );
  }
}

// ignore_for_file: avoid_dynamic_calls

final countries = [
  {
    'name': 'Узбекистан',
    'code': 'uz',
    'offices': 2,
    'width': 792.4873,
    'height': 516.87848,
    'children': [
      {
        'name': 'Ташкент',
        'code': 'UZ-TO',
        'address': 'Узбекистан, 100081, г. Ташкент, ул. Гавхар, д. 151а',
        'email': 'office@eriell.com',
        'phone': ['+998 (78) 120-32-87', '+998 (78) 120-32-90'],
      },
      {
        'name': 'Ташкент',
        'code': 'UZ-TK',
        'address': 'Узбекистан, 100081, г. Ташкент, ул. Гавхар, д. 151а',
        'email': 'office@eriell.com',
        'phone': ['+998 (78) 120-32-87', '+998 (78) 120-32-90'],
        'lat': 41.2581888,
        'lon': 69.1905856,
      },
      {
        'name': 'Карши',
        'code': 'UZ-QA',
        'address': 'Узбекистан, 180002, Карши, ул. Жайхун, д. 2',
        'email': 'office@eriell.com',
        'phone': ['+998 (78) 120-32-87'],
        'lat': 38.8352474,
        'lon': 65.7540438,
      }
    ],
  },
  {
    'name': 'Китай',
    'code': 'cn',
    'offices': 1,
    'width': 774.04419,
    'height': 569.65088,
    'children': [
      {
        'name': 'Пекин',
        'code': 'CN-11',
        'address':
            '''Room No 704-2, 7th floor, Bld. 3, Ronghua Middle street 22 (Yicheng Fortune Center B Block), Beijing Economic and Technology Development Zone, Beijing, 100176''',
        'email': 'beijing@eriell.com',
        'phone': ['+86 (10) 57926907'],
        'lat': 39.7975,
        'lon': 116.5723,
      },
    ],
  },
  {
    'name': 'Чехия',
    'code': 'cz',
    'offices': 1,
    'width': 612.45972,
    'height': 350.61844,
    'children': [
      {
        'name': 'Прага',
        'code': 'CZ-PR',
        'address': '''437/3 Veleslavinska, Prague 6 16200, Czech Republic''',
        'email': 'prague@eriell.eu',
        'phone': ['+420 (2) 51-550-196'],
        'lat': 50.0913623,
        'lon': 14.3551601,
      },
    ],
  },
  {
    'name': 'Австрия',
    'code': 'at',
    'offices': 1,
    'width': 612.93958,
    'height': 313.54865,
    'children': [
      {
        'name': 'Вена',
        'code': 'AT-9',
        'address': 'A-1040 Wien, Brucknerstraße 2/Top 1',
        'email': 'wien@eriell.com',
        'phone': ['+(43) 720-77-53-96'],
        'lat': 48.1990893,
        'lon': 16.3751712,
      },
    ],
  },
  {
    'name': 'Бангладеш',
    'code': 'bd',
    'offices': 1,
    'width': 437.80637,
    'height': 601.16034,
    'children': [
      {
        'name': 'Дакка',
        'code': 'BD-C',
        'address':
            '''Capita Balmoral, Bld. 2, United Nations Road, Baridhara, Dhaka 1212, Bangladesh''',
        'email': 'dhaka@eriell.com',
        'phone': ['+880 (017) 9533-2824'],
        'lat': 23.8028663,
        'lon': 90.4196081,
      },
    ],
  },
  {
    'name': 'Кипр',
    'code': 'cy',
    'offices': 1,
    'width': 607.74274,
    'height': 360.26913,
    'children': [
      {
        'name': 'Лимасол',
        'code': 'CY-02',
        'address':
            '''Agiou Athanasiou 46, Interlink Hermes Plaza, 4th floor, office 400, 4102 Limassol, Cyprus''',
        'email': 'cyprus@eriell.com',
        'phone': ['+357-25-02-9224', '+357-25-02-9225'],
        'lat': 34.701614,
        'lon': 33.0712852,
      },
    ],
  },
  {
    'name': 'Нидерланды',
    'code': 'nl',
    'offices': 1,
    'width': 612.54211,
    'height': 723.61865,
    'children': [
      {
        'name': 'Амстердам',
        'code': 'NL-NH',
        'address': '''Rapenburgerstraat 179 B, 1011VM, Amsterdam''',
        'email': 'eofs@eriell.com',
        'phone': ['+31206648694'],
        'lat': 52.3730796,
        'lon': 4.8924534,
      },
    ],
  },
  {
    'name': 'ОАЭ',
    'code': 'ae',
    'offices': 1,
    'width': 760.1441,
    'height': 612.53363,
    'children': [
      {
        'name': 'Дубай',
        'code': 'AE-DU',
        'address':
            '''Office 1004, Reef Tower, Cluster O, Jumeirah Lake Towers, Dubai, UAE''',
        'email': 'dubai@eriell.com',
        'phone': ['+971 (4) 550-79-00', '+971 (4) 277-67-30'],
        'lat': 25.0690625,
        'lon': 55.1411656,
      },
    ],
  },
];

const primaryColor = Color(0xff1B3470);

const inputTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

const bodyMediumTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

const regularTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.black,
);

class InteractiveMap extends StatelessWidget {
  const InteractiveMap();

  @override
  Widget build(BuildContext context) {
    return const SupportedCountriesMap();
  }
}

class SupportedCountriesMap extends StatefulWidget {
  const SupportedCountriesMap();

  @override
  State<SupportedCountriesMap> createState() => _SupportedCountriesMapState();
}

class _SupportedCountriesMapState extends State<SupportedCountriesMap> {
  final TransformationController _transformationController =
      TransformationController();
  var _stackIndex = 0;
  String countryName = '';

  @override
  void initState() {
    super.initState();
    const zoomFactor = 2.0;
    const xTranslate = 1050.0;
    const yTranslate = 100.0;
    _transformationController.value.setEntry(0, 0, zoomFactor);
    _transformationController.value.setEntry(1, 1, zoomFactor);
    _transformationController.value.setEntry(2, 2, zoomFactor);
    _transformationController.value.setEntry(0, 3, -xTranslate);
    _transformationController.value.setEntry(1, 3, -yTranslate);
  }

  final countryColor = const Color(0xffE1B506);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     Padding(
      //         padding: const EdgeInsets.only(right: 60),
      //         child: GestureDetector(
      //           onTap: () {
      //             SideSheet.right(
      //                 width: 300,
      //                 transitionDuration: const Duration(milliseconds: 100),
      //                 body: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Expanded(
      //                       child: SingleChildScrollView(
      //                         child: _stackIndex == 0
      //                             ? Column(
      //                                 children: [
      //                                   ...List.generate(
      //                                     countries.length,
      //                                     (index) => Card(
      //                                       color: Colors.grey.withOpacity(0.1),
      //                                       elevation: 0,
      //                                       margin: const EdgeInsets.fromLTRB(
      //                                           12, 6, 12, 4),
      //                                       child: ListTile(
      //                                         onTap: () => setState(() {
      //                                           countryName = countries[index]
      //                                                   ['code']
      //                                               .toString();
      //                                           _stackIndex = 1;
      //                                         }),
      //                                         title: Text(
      //                                           countries[index]['name']
      //                                               .toString(),
      //                                           style: inputTextStyle,
      //                                         ),
      //                                         leading: SvgPicture.asset(
      //                                           'assets/icons/${countries[index]['code']}.svg',
      //                                           width: 20,
      //                                           height: 20,
      //                                         ),
      //                                         trailing: Row(
      //                                           mainAxisSize: MainAxisSize.min,
      //                                           children: [
      //                                             Text(
      //                                               '${countries[index]['offices']} - ',
      //                                               style: bodyMediumTextStyle
      //                                                   .copyWith(
      //                                                       color:
      //                                                           Colors.black54),
      //                                             ),
      //                                             //const SizedBox(width: 8),
      //                                             SvgPicture.asset(
      //                                               'assets/icons/office.svg',
      //                                               width: 20,
      //                                               height: 20,
      //                                               colorFilter:
      //                                                   const ColorFilter.mode(
      //                                                 Colors.black54,
      //                                                 BlendMode.srcIn,
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         ),
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ],
      //                               )
      //                             : Material(
      //                                 child: Column(
      //                                   children: [
      //                                     ...List.generate(
      //                                       (countries
      //                                               .where(
      //                                                 (element) =>
      //                                                     element['code'] ==
      //                                                     countryName,
      //                                               )
      //                                               .first['children']! as List)
      //                                           .length,
      //                                       (index) {
      //                                         final country = (countries
      //                                                 .where(
      //                                                   (element) =>
      //                                                       element['code'] ==
      //                                                       countryName,
      //                                                 )
      //                                                 .first['children']!
      //                                             as List)[index];
      //                                         return Theme(
      //                                           data: ThemeData(
      //                                             dividerColor:
      //                                                 Colors.transparent,
      //                                           ),
      //                                           child: ExpansionTile(
      //                                             title: Text(
      //                                               (country as Map<String,
      //                                                       dynamic>)['name']
      //                                                   as String,
      //                                               style: const TextStyle(
      //                                                 fontSize: 18,
      //                                                 fontWeight:
      //                                                     FontWeight.bold,
      //                                               ),
      //                                             ),
      //                                             children: [
      //                                               Padding(
      //                                                 padding: const EdgeInsets
      //                                                     .symmetric(
      //                                                   horizontal: 16,
      //                                                 ),
      //                                                 child: Row(
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .start,
      //                                                   children: [
      //                                                     Text(
      //                                                       'Адрес: ',
      //                                                       style:
      //                                                           bodyMediumTextStyle,
      //                                                     ),
      //                                                     Flexible(
      //                                                       child: Text(
      //                                                         country['address']
      //                                                             as String,
      //                                                         style:
      //                                                             regularTextStyle,
      //                                                       ),
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                               const SizedBox(height: 8),
      //                                               Padding(
      //                                                 padding: const EdgeInsets
      //                                                     .symmetric(
      //                                                   horizontal: 16,
      //                                                 ),
      //                                                 child: Row(
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .start,
      //                                                   children: [
      //                                                     Text(
      //                                                       'Почта: ',
      //                                                       style:
      //                                                           bodyMediumTextStyle,
      //                                                     ),
      //                                                     GestureDetector(
      //                                                       onTap: () {
      //                                                         launchUrl(
      //                                                           Uri(
      //                                                             scheme:
      //                                                                 'mailto',
      //                                                             path: country[
      //                                                                     'email']
      //                                                                 as String,
      //                                                           ),
      //                                                         );
      //                                                       },
      //                                                       child: Text(
      //                                                         country['email']
      //                                                             as String,
      //                                                         style:
      //                                                             regularTextStyle,
      //                                                       ),
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                               const SizedBox(height: 8),
      //                                               Padding(
      //                                                 padding: const EdgeInsets
      //                                                     .symmetric(
      //                                                   horizontal: 16,
      //                                                 ),
      //                                                 child: Row(
      //                                                   crossAxisAlignment:
      //                                                       CrossAxisAlignment
      //                                                           .start,
      //                                                   children: [
      //                                                     Text(
      //                                                       'Телефон: ',
      //                                                       style:
      //                                                           bodyMediumTextStyle,
      //                                                     ),
      //                                                     Column(
      //                                                       children: [
      //                                                         ...(country['phone']
      //                                                                 as List)
      //                                                             .map(
      //                                                           (e) =>
      //                                                               GestureDetector(
      //                                                             onTap:
      //                                                                 () async {
      //                                                               await launchUrl(
      //                                                                 Uri(
      //                                                                   scheme:
      //                                                                       'tel',
      //                                                                   path: e,
      //                                                                 ),
      //                                                               );
      //                                                             },
      //                                                             child: Text(
      //                                                               e as String,
      //                                                               style: regularTextStyle
      //                                                                   .copyWith(
      //                                                                 decorationColor:
      //                                                                     Colors
      //                                                                         .blue,
      //                                                                 decoration:
      //                                                                     TextDecoration
      //                                                                         .underline,
      //                                                               ),
      //                                                             ),
      //                                                           ),
      //                                                         ),
      //                                                       ],
      //                                                     ),
      //                                                   ],
      //                                                 ),
      //                                               ),
      //                                             ],
      //                                           ),
      //                                         );
      //                                       },
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 context: context);
      //           },
      //           child: const Icon(Icons.menu),
      //         )),
      //   ],
      // ),
      body: IndexedStack(
        index: _stackIndex,
        children: [
          Visibility(
            visible: _stackIndex == 0,
            child: Stack(
              children: [
                InteractiveViewer(
                  maxScale: 75,
                  minScale: 0.5,
                  transformationController: _transformationController,
                  child: Container(
                    color: primaryColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SimpleMap(
                      instructions: SMapWorld.instructions,
                      defaultColor: Colors.grey.withOpacity(0.44),
                      callback: (id, name, tapdetails) {
                        setState(() {
                          countryName = id;
                          _stackIndex = 1;
                        });
                        // goToCountry(id);
                      },
                      countryBorder: const CountryBorder(color: Colors.grey),
                      colors: SMapWorldColors(
                        aT: countryColor,
                        bD: countryColor,
                        cY: countryColor,
                        cN: countryColor,
                        cZ: countryColor,
                        nL: countryColor,
                        aE: countryColor,
                        uZ: countryColor,
                      ).toMap(),
                      coordinates: [],
                      hitTestCallback: ({
                        required bool isIconTargeted,
                        required double lat,
                        required double lon,
                      }) {},
                      zoom: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _stackIndex == 1,
            child: Stack(
              children: [
                CountryPage(
                  country: countryName,
                  onBackPressed: () => setState(
                    () {
                      _stackIndex = 0;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CountryPage extends StatefulWidget {
  const CountryPage({
    required this.country,
    required this.onBackPressed,
  });
  final String country;
  final VoidCallback onBackPressed;

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage>
    with TickerProviderStateMixin {
  late String state;
  late String instruction;
  String country = '';

  late List<Map<String, dynamic>> properties;

  late Map<String, Color?> keyValuesPaires;

  final TransformationController _countryController =
      TransformationController();

  List<String> coordinates = [];
  bool isIconHovered = false;
  double relativeLat = 0;
  double relativeLon = 0;
  double width = 0;
  double height = 0;

  // @override
  // void didUpdateWidget(covariant CountryPage oldWidget) {
  //   setState(() {
  //     country = widget.country;
  //     instruction = getInstructions(country);
  //     properties = getProperties(instruction);
  //     properties
  //         .sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
  //     keyValuesPaires = {};
  //     final countryObj =
  //         countries.where((element) => element['code'] == country).first;
  //     final cities = countryObj['children']! as List;
  //     width = countryObj['width'] as double;
  //     height = countryObj['height'] as double;

  //     for (final element in properties) {
  //       keyValuesPaires.addAll(
  //         {
  //           element['id'].toString(): cities
  //                   .where(
  //                     (e) =>
  //                         (e as Map<String, dynamic>)['code'] == element['id'],
  //                   )
  //                   .isNotEmpty
  //               ? Colors.red.withOpacity(0.8)
  //               : element['color'] == null
  //                   ? const Color(0xffE1B506)
  //                   : element['color'] as Color,
  //         },
  //       );
  //     }
  //   });
  //   super.didUpdateWidget(oldWidget);
  // }

  void zoom(double lat, double lon) {
    const zoomFactor = 10.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double mapWidth = 0;
    double mapHeight = 0;
    if (screenWidth > screenHeight) {
      mapHeight = screenHeight;
      mapWidth = screenHeight * width / height;
    } else {
      mapWidth = screenWidth;
      mapHeight = screenWidth * height / width;
    }
    final translateX = -mapWidth * zoomFactor * lat -
        (screenWidth - mapWidth) * zoomFactor / 2 +
        screenWidth / 2;
    final translateY = -mapHeight * zoomFactor * lon -
        (screenHeight - mapHeight) * zoomFactor / 2 +
        screenHeight / 2;
    Matrix4 beginTransform = _countryController.value;
    Matrix4 endTransform = Matrix4.identity()
      ..translate(translateX, translateY)
      ..scale(zoomFactor);

    AnimationController animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    Animation<Matrix4> animation = Matrix4Tween(
      begin: beginTransform,
      end: endTransform,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    animation.addListener(() {
      setState(() {
        _countryController.value = animation.value;
      });
    });

    animationController.forward();
  }

  @override
  void initState() {
    country = widget.country;
    instruction = getInstructions(country);
    properties = getProperties(instruction);
    properties
        .sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
    keyValuesPaires = {};
    final countryObj =
        countries.where((element) => element['code'] == country).first;
    final cities = countryObj['children']! as List;
    width = countryObj['width'] as double;
    height = countryObj['height'] as double;
    coordinates = cities
        .where((element) => element['lat'] != null)
        .map((e) => '${e['lat']},${e['lon']}')
        .toList();
    for (final element in properties) {
      keyValuesPaires.addAll(
        {
          element['id'].toString(): cities
                  .where(
                    (e) => (e as Map<String, dynamic>)['code'] == element['id'],
                  )
                  .isNotEmpty
              ? Colors.red.withOpacity(0.8)
              : element['color'] == null
                  ? const Color(0xffE1B506)
                  : element['color'] as Color,
        },
      );
    }

    state = 'Tap a state, prefecture or province';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: primaryColor),
      //   leading: IconButton(
      //     onPressed: widget.onBackPressed,
      //     icon: const Icon(
      //       Icons.arrow_back,
      //       color: Colors.white,
      //     ),
      //   ),
      // ),
      body: InteractiveViewer(
        maxScale: 75,
        minScale: 1,
        onInteractionUpdate: (details) {
          setState(() {
            print(details.scale);
          });
        },
        transformationController: _countryController,
        child: Column(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                if (isIconHovered) {
                  zoom(relativeLat, relativeLon);
                }
              },
              child: Container(
                color: primaryColor,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SimpleMap(
                  defaultColor: primaryColor,
                  key: Key(properties.toString()),
                  colors: keyValuesPaires,
                  instructions: instruction,
                  callback: (id, name, tapDetails) {
                    setState(() {
                      state = name;

                      final i = properties
                          .indexWhere((element) => element['id'] == id);

                      properties[i]['color'] =
                          properties[i]['color'] == Colors.green
                              ? null
                              : Colors.green;
                      keyValuesPaires[properties[i]['id'] as String] =
                          properties[i]['color'] as Color;
                    });
                  },
                  coordinates: coordinates,
                  hitTestCallback: ({
                    required bool isIconTargeted,
                    required double lat,
                    required double lon,
                  }) {
                    if (isIconHovered != isIconTargeted) {
                      isIconHovered = isIconTargeted;
                      if (isIconHovered) {
                        relativeLat = lat;
                        relativeLon = lon;
                      }
                    }
                  },
                  zoom: _countryController.value.getMaxScaleOnAxis(),
                  // zoom: _countryController.value
                  //     .getRow(0)
                  //     .distanceTo(_countryController.value.getRow(1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getProperties(String input) {
    final instructions = json.decode(input) as Map<String, dynamic>;

    final paths = instructions['i'] as List;

    final properties = <Map<String, dynamic>>[];

    for (final element in paths) {
      properties.add({
        'name': element['n'],
        'id': element['u'],
        'color': null,
      });
    }

    return properties;
  }

  String getInstructions(String id) {
    switch (id) {
      case 'ar':
        return SMapArgentina.instructions;

      case 'at':
        return SMapAustria.instructions;

      case 'ad':
        return SMapAndorra.instructions;

      case 'ao':
        return SMapAngola.instructions;

      case 'am':
        return SMapArmenia.instructions;

      case 'au':
        return SMapAustralia.instructions;

      case 'az':
        return SMapAzerbaijan.instructions;

      case 'bs':
        return SMapBahamas.instructions;

      case 'bh':
        return SMapBahrain.instructions;

      case 'bd':
        return SMapBangladesh.instructions;

      case 'by':
        return SMapBelarus.instructions;

      case 'be':
        return SMapBelgium.instructions;

      case 'bt':
        return SMapBhutan.instructions;

      case 'bo':
        return SMapBolivia.instructions;

      case 'bw':
        return SMapBotswana.instructions;

      case 'br':
        return SMapBrazil.instructions;

      case 'bn':
        return SMapBrunei.instructions;

      case 'bg':
        return SMapBulgaria.instructions;

      case 'bf':
        return SMapBurkinaFaso.instructions;

      case 'bi':
        return SMapBurundi.instructions;

      case 'ca':
        return SMapCanada.instructions;

      case 'cm':
        return SMapCameroon.instructions;

      case 'cf':
        return SMapCentralAfricanRepublic.instructions;

      case 'cv':
        return SMapCapeVerde.instructions;

      case 'td':
        return SMapChad.instructions;

      case 'cn':
        return SMapChina.instructions;

      case 'ch':
        return SMapSwitzerland.instructions;

      case 'cd':
        return SMapCongoDR.instructions;

      case 'cg':
        return SMapCongoBrazzaville.instructions;

      case 'co':
        return SMapColombia.instructions;

      case 'cr':
        return SMapCostaRica.instructions;

      case 'hr':
        return SMapCroatia.instructions;

      case 'cu':
        return SMapCuba.instructions;

      case 'cl':
        return SMapChile.instructions;

      case 'ci':
        return SMapIvoryCoast.instructions;

      case 'cy':
        return SMapCyprus.instructions;

      case 'cz':
        return SMapCzechRepublic.instructions;

      case 'dk':
        return SMapDenmark.instructions;

      case 'dj':
        return SMapDjibouti.instructions;

      case 'do':
        return SMapDominicanRepublic.instructions;

      case 'ec':
        return SMapEcuador.instructions;

      case 'es':
        return SMapSpain.instructions;

      case 'eg':
        return SMapEgypt.instructions;

      case 'et':
        return SMapEthiopia.instructions;

      case 'sv':
        return SMapElSalvador.instructions;

      case 'ee':
        return SMapEstonia.instructions;

      case 'fo':
        return SMapFaroeIslands.instructions;

      case 'fi':
        return SMapFinland.instructions;

      case 'fr':
        return SMapFrance.instructions;

      case 'gb':
        return SMapUnitedKingdom.instructions;

      case 'ge':
        return SMapGeorgia.instructions;

      case 'de':
        return SMapGermany.instructions;

      case 'gr':
        return SMapGreece.instructions;

      case 'gt':
        return SMapGuatemala.instructions;

      case 'gn':
        return SMapGuinea.instructions;

      case 'hi':
        return SMapHaiti.instructions;

      case 'hk':
        return SMapHongKong.instructions;

      case 'hn':
        return SMapHonduras.instructions;

      case 'hu':
        return SMapHungary.instructions;

      case 'in':
        return SMapIndia.instructions;

      case 'id':
        return SMapIndonesia.instructions;

      case 'il':
        return SMapIsrael.instructions;

      case 'ir':
        return SMapIran.instructions;

      case 'iq':
        return SMapIraq.instructions;

      case 'ie':
        return SMapIreland.instructions;

      case 'it':
        return SMapItaly.instructions;

      case 'jm':
        return SMapJamaica.instructions;

      case 'jp':
        return SMapJapan.instructions;

      case 'kz':
        return SMapKazakhstan.instructions;

      case 'ke':
        return SMapKenya.instructions;

      case 'xk':
        return SMapKosovo.instructions;

      case 'kg':
        return SMapKyrgyzstan.instructions;

      case 'la':
        return SMapLaos.instructions;

      case 'lv':
        return SMapLatvia.instructions;

      case 'li':
        return SMapLiechtenstein.instructions;

      case 'lt':
        return SMapLithuania.instructions;

      case 'lu':
        return SMapLuxembourg.instructions;

      case 'mk':
        return SMapMacedonia.instructions;

      case 'ml':
        return SMapMali.instructions;

      case 'mt':
        return SMapMalta.instructions;

      case 'mz':
        return SMapMozambique.instructions;

      case 'mx':
        return SMapMexico.instructions;

      case 'md':
        return SMapMoldova.instructions;

      case 'me':
        return SMapMontenegro.instructions;

      case 'ma':
        return SMapMorocco.instructions;

      case 'mm':
        return SMapMyanmar.instructions;

      case 'my':
        return SMapMalaysia.instructions;

      case 'na':
        return SMapNamibia.instructions;

      case 'np':
        return SMapNepal.instructions;

      case 'nl':
        return SMapNetherlands.instructions;

      case 'nz':
        return SMapNewZealand.instructions;

      case 'ni':
        return SMapNicaragua.instructions;

      case 'ng':
        return SMapNigeria.instructions;

      case 'no':
        return SMapNorway.instructions;

      case 'om':
        return SMapOman.instructions;

      case 'ps':
        return SMapPalestine.instructions;

      case 'pk':
        return SMapPakistan.instructions;

      case 'ph':
        return SMapPhilippines.instructions;

      case 'pa':
        return SMapPanama.instructions;

      case 'pe':
        return SMapPeru.instructions;

      case 'pr':
        return SMapPuertoRico.instructions;

      case 'py':
        return SMapParaguay.instructions;

      case 'pl':
        return SMapPoland.instructions;

      case 'pt':
        return SMapPortugal.instructions;

      case 'qa':
        return SMapQatar.instructions;

      case 'ro':
        return SMapRomania.instructions;

      case 'ru':
        return SMapRussia.instructions;

      case 'rw':
        return SMapRwanda.instructions;

      case 'sa':
        return SMapSaudiArabia.instructions;

      case 'rs':
        return SMapSerbia.instructions;

      case 'sd':
        return SMapSudan.instructions;

      case 'sg':
        return SMapSingapore.instructions;

      case 'sl':
        return SMapSierraLeone.instructions;

      case 'sk':
        return SMapSlovakia.instructions;

      case 'si':
        return SMapSlovenia.instructions;

      case 'kr':
        return SMapSouthKorea.instructions;

      case 'lk':
        return SMapSriLanka.instructions;

      case 'se':
        return SMapSweden.instructions;

      case 'sy':
        return SMapSyria.instructions;

      case 'tw':
        return SMapTaiwan.instructions;

      case 'tj':
        return SMapTajikistan.instructions;

      case 'th':
        return SMapThailand.instructions;

      case 'tr':
        return SMapTurkey.instructions;

      case 'ug':
        return SMapUganda.instructions;

      case 'ua':
        return SMapUkraine.instructions;

      case 'ae':
        return SMapUnitedArabEmirates.instructions;

      case 'us':
        return SMapUnitedStates.instructions;

      case 'uy':
        return SMapUruguay.instructions;

      case 'uz':
        return SMapUzbekistan.instructions;

      case 've':
        return SMapVenezuela.instructions;

      case 'vn':
        return SMapVietnam.instructions;

      case 'ye':
        return SMapYemen.instructions;

      case 'za':
        return SMapSouthAfrica.instructions;

      case 'zm':
        return SMapZambia.instructions;

      case 'zw':
        return SMapZimbabwe.instructions;

      default:
        return 'NOT SUPPORTED';
    }
  }
}
