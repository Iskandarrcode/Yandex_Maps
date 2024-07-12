import 'package:yandex_mapkit/yandex_mapkit.dart';

class Restorant {
  final String id;
  String name;
  String imageUrl;
  String phoneNumber;
  Point location;

  Restorant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
    required this.location,
  });
}
