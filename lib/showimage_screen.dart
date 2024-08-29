import 'dart:io';

import 'package:flutter/material.dart';

class ShowimageScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables, non_constant_identifier_names
  final image_Path;
  // ignore: non_constant_identifier_names
  const ShowimageScreen({super.key, this.image_Path});

  @override
  State<ShowimageScreen> createState() => _ShowimageScreenState();
}

class _ShowimageScreenState extends State<ShowimageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
        centerTitle: true,
      ),
      body: Expanded(child: Image.file(
        fit: BoxFit.cover,
        File(widget.image_Path))),
    );
  }


}