import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

class FavouritePlacesNotifier extends StateNotifier<List<FavouritePlace>>{
  FavouritePlacesNotifier(): super([]);

  void addFavouritePlace(FavouritePlace place) async {

    //changing the path of image stored locally
    final appDir = await syspaths.getApplicationCacheDirectory();
    final fileName = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$fileName');

    final newPlace=FavouritePlace(id: place.id, name: place.name, image: copiedImage, location: place.location);

    //adding place in local database
    final db= await _getDatabase();
    db.insert('favourite_places', {
      'id': newPlace.id,
      'name': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'long': newPlace.location.longitude,
      'address': newPlace.location.address
    });
    //adding place in the in memory list
    state=[...state,newPlace];
  }

  Future<void> getFavouritePlaces() async {
    final db= await _getDatabase();
    final data = await db.query('favourite_places');
    final favouritePlaces = data.map((item)=>FavouritePlace(
        id: item['id'] as String,
        name: item['name'] as String,
        image: File(item['image'] as String),
        location: PlaceLocation(latitude: item['lat'] as double,longitude: item['long'] as double, address: item['address'] as String)
    )).toList();
    state = favouritePlaces;
  }
}

final favouritePlacesProvider=StateNotifierProvider<FavouritePlacesNotifier,List<FavouritePlace>> ((ref){
  return FavouritePlacesNotifier();
});

Future<Database> _getDatabase() async{
  final dbPath = await sql.getDatabasesPath();
  final db= await sql.openDatabase(
      path.join(dbPath,'places.db'),
      onCreate: (db,version){
        return db.execute('CREATE TABLE favourite_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, long REAL, address TEXT)');
      },
      version: 1
  );
  return db;
}