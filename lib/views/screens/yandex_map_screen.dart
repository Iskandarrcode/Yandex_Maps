import 'package:dars9/cubits/restorant_cubit.dart';
import 'package:dars9/cubits/restorant_state.dart';
import 'package:dars9/services/location_service.dart';
import 'package:dars9/views/widgets/alert_dialog.dart';
import 'package:dars9/views/widgets/loc_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class YandexMapScreen extends StatefulWidget {
  const YandexMapScreen({super.key});

  @override
  State<YandexMapScreen> createState() => _YandexMapScreenState();
}

class _YandexMapScreenState extends State<YandexMapScreen> {
  late YandexMapController mapController;
  final _searchController = TextEditingController();
  List<MapObject>? polylines;
  List<PlacemarkMapObject> makers = [];

  Point myCurrentLocation = const Point(
    latitude: 41.2856806,
    longitude: 69.9034646,
  );

  Point najotTalim = const Point(
    latitude: 41.2856806,
    longitude: 69.2034646,
  );

  void onMapCreated(YandexMapController controller) {
    mapController = controller;
    mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: najotTalim,
          zoom: 20,
        ),
      ),
    );
    setState(() {});
  }

  void onCameraPositionChanged(
    CameraPosition position,
    CameraUpdateReason reason,
    bool finished,
  ) async {
    myCurrentLocation = position.target;
    // if (finished) {
    //   polylines = await YandexMapService.getDirection(
    //     najotTalim,
    //     myCurrentLocation,
    //   );
    // }
  }

  Point? myLocation;

  Future<SuggestSessionResult> _suggest() async {
    final resultWithSession = await YandexSuggest.getSuggestions(
      text: _searchController.text,
      boundingBox: const BoundingBox(
        northEast: Point(latitude: 56.0421, longitude: 38.0284),
        southWest: Point(latitude: 55.5143, longitude: 37.24841),
      ),
      suggestOptions: const SuggestOptions(
        suggestType: SuggestType.geo,
        suggestWords: true,
        userPosition: Point(latitude: 56.0321, longitude: 38),
      ),
    );

    return await resultWithSession.$2;
  }

  @override
  void initState() {
    super.initState();
    context.read<RestorantCubit>().getRestorant();

    LocationService.determinePosition().then(
      (value) {
        if (value != null) {
          myLocation = Point(
            latitude: value.latitude,
            longitude: value.longitude,
          );
          setState(() {});
        }
      },
    );
  }

  late int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<RestorantCubit, RestorantState>(
          builder: (context, state) {
        if (state is InitialState || state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final restorant = context.read<RestorantCubit>().restorants;

        return Stack(
          children: [
            YandexMap(
              onMapLongTap: (argument) async {
  // Add the new marker immediately to the list
  makers.add(
    PlacemarkMapObject(
      text: PlacemarkText(
        text: restorant.isNotEmpty ? restorant[restorant.length - 1].name : "New Location",
        style: const PlacemarkTextStyle(
          color: Colors.white,
          outlineColor: Colors.white,
        ),
      ),
      onTap: (mapObject, point) async {
        showDialog(
          context: context,
          builder: (context) {
            return LocAlert(location: point);
          },
        );
      },
      mapId: MapObjectId(UniqueKey().toString()),
      point: Point(
        latitude: argument.latitude,
        longitude: argument.longitude,
      ),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage(
            "assets/route_start.png",
          ),
        ),
      ),
    ),
  );
  setState(() {});

  // Show dialog after updating the state
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialogs(location: argument);
    },
  );
},

              onMapCreated: onMapCreated,
              onCameraPositionChanged: onCameraPositionChanged,
              nightModeEnabled: true,
              mapObjects: [
                PlacemarkMapObject(
                  mapId: const MapObjectId("najotTalim"),
                  point: najotTalim,
                  onTap: (mapObject, point) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return LocAlert(location: point);
                      },
                    );
                  },
                  icon: PlacemarkIcon.single(
                    PlacemarkIconStyle(
                      image: BitmapDescriptor.fromAssetImage(
                        "assets/route_start.png",
                      ),
                    ),
                  ),
                ),

                ...makers,
                ...?polylines,
              ],
            ),

            Positioned(
              bottom: 120,
              right: 15,
              child: ZoomTapAnimation(
                onTap: () async {
                  mapController.moveCamera(
                    CameraUpdate.zoomIn(),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(132, 0, 0, 0),
                  ),
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.add,
                      size: 35,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: 15,
              child: ZoomTapAnimation(
                onTap: () async {
                  mapController.moveCamera(
                    CameraUpdate.zoomOut(),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(132, 0, 0, 0),
                  ),
                  child: const Icon(
                    CupertinoIcons.minus,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 200,
              right: 15,
              child: ZoomTapAnimation(
                onTap: () {
                  mapController.moveCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: myLocation ?? Point(latitude: 0, longitude: 0),
                        zoom: 20,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(132, 0, 0, 0),
                  ),
                  child: const Icon(
                    Icons.my_location_rounded,
                    size: 35,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) async {
                    final res = await _suggest();
                    if (res.items != null) {
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(
                    hintText: "Search Location",
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
