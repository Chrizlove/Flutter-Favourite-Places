import 'dart:convert';
import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:favourite_places/screens/maps_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInputWidget extends StatefulWidget{
  const LocationInputWidget({super.key, required this.onPickLocation});
  final void Function(PlaceLocation location) onPickLocation;
  @override
  State<StatefulWidget> createState() {
    return _LocationInputWidgetState();
  }
}

class _LocationInputWidgetState extends State<LocationInputWidget>{
  PlaceLocation? _pickedLocation;
  bool _isFetchingLocation=false;
  @override
  Widget build(BuildContext context) {
    Widget previewContent= Text(''
        'No location chosen yet!',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Theme.of(context).colorScheme.onBackground
      ),
    );

    if(_isFetchingLocation){
      previewContent= const CircularProgressIndicator();
    }

    if(_pickedLocation!=null){
      previewContent=Image.network(locationImage,fit: BoxFit.cover,height: double.infinity,width: double.infinity,);
    }
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                  width: 3
              )
          ),
          height: 200,
          width: double.infinity,
          child: previewContent
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.location_on),
                label: const Text('Fetch Location')
            ),
            TextButton.icon(
                onPressed: (){
                _switchToMapsScreenForSelecting();
                },
                icon: const Icon(Icons.map),
                label: const Text('Choose location')
            ),
          ],
        )
      ],
    );
  }

  void _getCurrentLocation() async {

    //asking for location permission
    Location location =  Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isFetchingLocation=true;
    });

    locationData = await location.getLocation();
    final lat=locationData.latitude;
    final long=locationData.longitude;
    if(lat==null || long==null){
      return;
    }
    _savePlace(lat, long);
  }

  String get locationImage{
    if(_pickedLocation==null) return '';
    final lat=_pickedLocation!.latitude;
    final long=_pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$long&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$long&key=AIzaSyCtomysiqPj8O3kyFDQP6jEtUp53aqDNIs';
  }

  void _switchToMapsScreenForSelecting() async {
    final location = await Navigator.of(context).push<LatLng>(MaterialPageRoute(builder: (ctx)=> const MapsScreen()));
    if(location==null) return;
    setState(() {
      _isFetchingLocation=true;
    });
    _savePlace(location.latitude, location.longitude);
  }

  //gets address by latlng and changes the state
  Future<void> _savePlace(double lat, double long) async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=AIzaSyCtomysiqPj8O3kyFDQP6jEtUp53aqDNIs');
    final response = await http.get(url);
    final decodedResponse = json.decode(response.body);
    final address = decodedResponse['results'][0]['formatted_address'];
    //print(address);
    setState(() {
      _pickedLocation = PlaceLocation(latitude: lat, longitude: long, address: address);
      _isFetchingLocation=false;
    });
    widget.onPickLocation(_pickedLocation!);
    //print(locationData.longitude);
  }
}