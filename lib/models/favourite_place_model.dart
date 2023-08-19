
import 'dart:io';

class PlaceLocation{
  const PlaceLocation({required this.latitude, required this.longitude, required this.address});
  final double latitude;
  final double longitude;
  final String address;
}

class FavouritePlace{
  const FavouritePlace({
    required this.id,
    required this.name,
    required this.image,
    required this.location
  });

  final String name;
  final String id;
   final File image;
  final PlaceLocation location;
}