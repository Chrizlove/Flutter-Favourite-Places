import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:favourite_places/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouritePlaceDetailScreen extends ConsumerWidget{
  const FavouritePlaceDetailScreen({super.key, required this.place});
  final FavouritePlace place;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
          appBar: AppBar(
            title: Text(place.name),
          ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,

              child: Column(
                children: [
                  GestureDetector(
                    onTap:(){
                      _switchToMapsScreenFromDetails(place,context);
                    },
                    child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          locationImage
                        ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent,Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                    ),
                    child: Text(
                      place.location.address,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 18
                    ),
                      textAlign: TextAlign.center,
                  )
                  )
                ],
              )
          )
        ],
      )
    );
  }


  String get locationImage{
    final lat=place.location.latitude;
    final long=place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyCtomysiqPj8O3kyFDQP6jEtUp53aqDNIs';
  }

  //switches to mapsScreen when location avatar is tapped
  void _switchToMapsScreenFromDetails(FavouritePlace place, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx)=>  MapsScreen(location: PlaceLocation(
            latitude: place.location.latitude,
            longitude: place.location.longitude,
            address: ''
        ),
          isSelecting: false,
        )
    ));
  }
}