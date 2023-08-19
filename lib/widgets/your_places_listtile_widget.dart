import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:flutter/material.dart';
import 'package:favourite_places/screens/favourite_place_detail_screen.dart';

class YourPlacesListTileWidget extends StatelessWidget{
  const YourPlacesListTileWidget({super.key, required this.place});
  final FavouritePlace place;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: FileImage(place.image),
      ),
      onTap: (){
        _switchToPlaceDetailScreen(context,place);
      },
      title: Text(
          place.name,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground,
          fontSize: 20
        ),
      ),
      subtitle: Text(
        place.location.address,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 12
        ),
      ),
    );
  }


  void _switchToPlaceDetailScreen(BuildContext context, FavouritePlace place) {
    Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx)=> FavouritePlaceDetailScreen(place: place)
          ));
  }
}