import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:dars9/cubits/restorant_cubit.dart';
import 'package:dars9/cubits/restorant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class LocAlert extends StatelessWidget {
  final Point location;
  const LocAlert({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestorantCubit, RestorantState>(
      builder: (context, state) {
        if (state is InitialState) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Productlar mavjud emas"),
            ),
          );
        } else if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is ErrorState) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is LoadedState) {
          final restoranInfo = state.restorants;

          if (restoranInfo == null || restoranInfo.isEmpty) {
            return const Center(
              child: Text("No restorants available."),
            );
          }

          // final index = restoranInfo.indexWhere(
          //   (element) => element.location == location,
          // );

          print("----------------");
          print(restoranInfo[0].name);

          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                Image.network(restoranInfo[0].imageUrl),
                const SizedBox(height: 25),
                Text(
                  restoranInfo[0].name, // Assuming there's a name property
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  restoranInfo[0]
                      .phoneNumber, // Assuming there's a description property
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 20),
              ],
            ),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Card(
                      color: Color.fromARGB(127, 16, 13, 218),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ZoomTapAnimation(
                    onTap: () {},
                    child: const Card(
                      color: Color.fromARGB(127, 16, 13, 218),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 8,
                          bottom: 8,
                        ),
                        child: Text(
                          "Go",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("Unknown state."),
          );
        }
      },
    );
  }
}
