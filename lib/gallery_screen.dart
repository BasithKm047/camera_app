import 'dart:io';

import 'package:flutter/material.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}


class _GalleryScreenState extends State<GalleryScreen> {
  List<FileSystemEntity>imageFiles=[];
  



  Future<void> _loadImages() async{
    const myGalleryPath='/storage/emulated/0/MyAppGallery';

    final direcoryExists=await Directory(myGalleryPath).exists();
    if(direcoryExists){
      final  myGallery=Directory(myGalleryPath);
      setState(() {
        imageFiles=myGallery.listSync().where((item)=>item.path.endsWith('.jpg')||item.path.endsWith('.png')).toList();
      });
    }

  }
  
@override
  void initState() {
    super.initState();
    _loadImages();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gallery'),
        centerTitle: true,
      ),
      body: imageFiles.isEmpty?
      const Center(child: Text('No Images FOund'))
      :GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 5.0,
        ),
        itemCount: imageFiles.length,
         itemBuilder: (context, index) {
           
           return GestureDetector(
            onTap: (){
             _showImageDailogue(imageFiles[index].path);

            
            },
             child: Image.file(
                       
              File(imageFiles[index].path),
              fit: BoxFit.cover,
              ),
           );
         },
        ),
      
    );
  }

  _showImageDailogue(String imagePath){
    showDialog(context: context, builder: (context) {
      
      return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Image.file(File(imagePath),
          fit: BoxFit.contain,
          ),
        ),

      );
    },);

  }
}