import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends StatefulWidget{
  const MapsScreen({
    super.key,
    this.location=const PlaceLocation(
        latitude: 37.422,
        longitude: -122.084,
        address: ''
    ),
    this.isSelecting = true
  });
  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<StatefulWidget> createState() {
    return _MapsScreenState();
  }
}

class _MapsScreenState extends State<MapsScreen>{
  LatLng? _pickedLocation;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: widget.isSelecting ? const Text('Pick a location') : const Text('Your Location'),
           actions: [
             if(widget.isSelecting)
               IconButton(
                onPressed: (){
                Navigator.of(context).pop(_pickedLocation);
                },
                icon: const Icon(Icons.save)
           )
       ],
     ),
     body: GoogleMap(
       onTap: widget.isSelecting==false ? null : (position){
         setState(() {
           _pickedLocation=position;
         });
       },
       initialCameraPosition: CameraPosition(
         target: LatLng(widget.location.latitude, widget.location.longitude),
         zoom: 16
       ),
       markers: (_pickedLocation==null && widget.isSelecting) ? {} :  {
         Marker(
           markerId: const MarkerId('m1'),
           position: _pickedLocation ?? LatLng(widget.location.latitude, widget.location.longitude),
         )
       },
     )
   );
  }
}