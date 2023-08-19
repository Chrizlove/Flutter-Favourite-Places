import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInputWidget extends StatefulWidget{
  const ImageInputWidget({super.key, required this.onPickImage});
  final void Function(File image) onPickImage;

  @override
  State<StatefulWidget> createState() {
    return _ImageInputWidget();
  }
}

class _ImageInputWidget extends State<ImageInputWidget>{
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {

    Widget mainContent =  TextButton.icon(
        onPressed: _openCamera,
        icon: const Icon(Icons.camera),
        label: const Text('Click a Picture!')
    );

    if(_selectedImage!=null){
      mainContent=GestureDetector(
        onTap: _openCamera,
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            width: 3
        )
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: mainContent
    );
  }
  
  void _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.camera,maxWidth: 600);
    if(pickedImage!=null){
      setState(() {
        _selectedImage=File(pickedImage.path);
      });
    }
    widget.onPickImage(_selectedImage!);
  }
}