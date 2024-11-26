import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final int id;
  final String name;
  final LatLng latLng;
  PlaceModel({
    required this.id,
    required this.name,
    required this.latLng,
  });
}

List<PlaceModel> places = [
  PlaceModel(
    id: 1,
    name: 'Abdeen Palace Museum',
    latLng: const LatLng(
      30.043182156105292,
      31.247954399827393,
    ),
  ),
  PlaceModel(
    id: 2,
    name: '10th of Rammadan City',
    latLng: const LatLng(
      30.30504835265243,
      31.7327783861651,
    ),
  ),
  PlaceModel(
    id: 3,
    name: '6th of October City',
    latLng: const LatLng(
      29.964116985576734,
      30.938472979221604,
    ),
  ),
  PlaceModel(
    id: 4,
    name: 'Ebn Elsham',
    latLng: const LatLng(
      30.018958837549985,
      31.421072310384762,
    ),
  ),
];
