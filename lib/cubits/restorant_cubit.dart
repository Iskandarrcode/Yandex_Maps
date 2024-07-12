import 'package:bloc/bloc.dart';
import 'package:dars9/cubits/restorant_state.dart';
import 'package:dars9/data/models/restorant_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class RestorantCubit extends Cubit<RestorantState> {
  RestorantCubit() : super(InitialState());

  List<Restorant> restorants = [];

  Future<void> getRestorant() async {
    try {
      emit(LoadingState());
      await Future.delayed(const Duration(milliseconds: 400));

      emit(LoadedState(restorants));
    } catch (e) {
      print("Restorant kelishida hatolik");
      emit(ErrorState("Restorant kelishida xatolik"));
    }
  }

  Future<void> addProducts({
    required String id,
    required String name,
    required String phoneNumber,
    required String imageUrl,
    required Point location,
  }) async {
    try {
      if (state is LoadedState) {
        restorants = (state as LoadedState).restorants!;
      }
      emit(LoadingState());
      Future.delayed(const Duration(microseconds: 400));

      restorants.add(
        Restorant(
          id: id,
          name: name,
          phoneNumber: phoneNumber,
          imageUrl: imageUrl,
          location: location,
        ),
      );
      emit(LoadedState(restorants));
    } catch (e) {
      print("Restoran qo'shishda xatolik");
      emit(ErrorState("Restoran qo'shishda xatolik bor"));
    }
    print(restorants[0].location);
  }
}
