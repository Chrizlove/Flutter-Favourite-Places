import 'package:favourite_places/providers/favourite_places_provider.dart';
import 'package:favourite_places/screens/add_new_place_screen.dart';
import 'package:favourite_places/widgets/your_places_listtile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favourite_places/models/favourite_place_model.dart';

List<FavouritePlace> _favouritePlacesList=[];
class YourPlacesScreen extends ConsumerStatefulWidget{
  const YourPlacesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _YourPlacesScreenState();
  }
}

class _YourPlacesScreenState extends ConsumerState<YourPlacesScreen>{
  late Future<void> _placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture=ref.read(favouritePlacesProvider.notifier).getFavouritePlaces();
  }
  @override
  Widget build(BuildContext context) {
    _favouritePlacesList=ref.watch(favouritePlacesProvider);
    Widget mainContent =ListView.builder(
        itemCount: _favouritePlacesList.length,
        itemBuilder: (ctx,index)=> YourPlacesListTileWidget(place: _favouritePlacesList[index])
    );

    if(_favouritePlacesList.isEmpty){
      mainContent= Center(
        child: Text(
          'No favourite places present',
           style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontSize: 20
        )
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
              onPressed: _switchToAddNewPlaceScreen,
              icon: const Icon(Icons.add)
          )
        ],
      ),
      body: mainContent
    );
  }

  //switches to the add new place screen
  void _switchToAddNewPlaceScreen() {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx)=> const AddNewPlaceScreen()
  ));
  }
}