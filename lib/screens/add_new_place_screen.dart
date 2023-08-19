import 'dart:io';
import 'package:favourite_places/models/favourite_place_model.dart';
import 'package:favourite_places/providers/favourite_places_provider.dart';
import 'package:favourite_places/widgets/image_input_widget.dart';
import 'package:favourite_places/widgets/location_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _nameController= TextEditingController();
File? _selectedImage;
PlaceLocation? _selectedLocation;

class AddNewPlaceScreen extends ConsumerWidget{
  const AddNewPlaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Place'),
      ),
      body:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
        child: Column(
            children: [
               TextField(
                maxLength: 30,
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                 style: Theme.of(context).textTheme.labelMedium!.copyWith(
                     color: Theme.of(context).colorScheme.onBackground
                 ),
              ),
              const SizedBox(
                height: 8,
              ),
               ImageInputWidget(onPickImage: (image){
                _selectedImage=image;
              }),
              const SizedBox(
                height: 16,
              ),
               LocationInputWidget(onPickLocation: (location){
                _selectedLocation=location;
              }),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 40,
                decoration:  BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                ),
                child: TextButton.icon(
                    onPressed: (){
                      final enteredName = _nameController.text.trim();
                      if(enteredName==null || enteredName.isEmpty || _selectedImage==null || _selectedLocation==null){
                        return;
                      }
                      ref.read(favouritePlacesProvider.notifier).addFavouritePlace(
                          FavouritePlace(id: DateTime.now().toString(), name: _nameController.text,image: _selectedImage!, location: _selectedLocation!)
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                        'Save',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    )
                ),
              )
            ],
        ),
      ),
    );
  }
}