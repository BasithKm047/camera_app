import 'dart:async';

import 'package:camera/camera.dart';
import 'package:camera_app/gallery_screen.dart';
import 'package:camera_app/showimage_screen.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;
  XFile? pictures;
  bool isFlash = false;
  bool isFrontCamera = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null ||
        cameraController!.value.isInitialized == false) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupcamera();
    }
  }

  @override
  void initState() {
    _setupcamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    if (cameraController == null ||
        cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text(style: TextStyle(color: Colors.black), 'Camera'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                // height: double.infinity,
                height: 550.0,
                width: 400,
                // width: double.infinity,
                child: CameraPreview(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isFlash=!isFlash;
                                });
                              },
                              icon: Icon(
                                  size: 45.0,
                                  color: Colors.white,
                                  isFlash ? Icons.flash_on : Icons.flash_off)),
                        )
                      ],
                    ),
                    cameraController!)),
            Row(
              children: [
                Expanded(
                  child: IconButton(
                    iconSize: 45.0,
                    onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GalleryScreen(),));
                    
                  }, icon: const Icon(Icons.folder)),
                ),
                Expanded(
                  child: IconButton(
                      iconSize: 45.0,
                      onPressed: () async {
                        _toggleFlash();
                        XFile pictures =
                            await cameraController!.takePicture();
                        // Gal.putImage(pictures.path);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ShowimageScreen(
                            image_Path: pictures.path,
                          ),
                        ));
                       await _saveToGallery(pictures);
                      },
                      icon: const Icon(Icons.camera)),
                ),
                Expanded(
                  child: IconButton(
                      iconSize: 45.0,
                      onPressed: () {
                        _toggleCamera();
                      },
                      icon: const Icon(Icons.rotate_left_outlined)),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  Future<void> _setupcamera() async {
    List<CameraDescription> camera = await availableCameras();
    if (camera.isNotEmpty) {
      setState(() {
        cameras = camera;
        cameraController = CameraController(
            camera[isFrontCamera ? 1 : 0], ResolutionPreset.medium);
      });
    }
    cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      print(e);
    });
  }

  Future<void> _toggleFlash() async {
    if (cameraController == null && !cameraController!.value.isInitialized) {
      return;
    }
    if(isFlash){
       cameraController!.setFlashMode(FlashMode.torch);

    Timer(const Duration(seconds: 1), ()async{
       await cameraController!.setFlashMode(FlashMode.off);
    });

    }
   
   
  }

  Future<void> _toggleCamera() async {
    setState(() {
      isFrontCamera = !isFrontCamera;
    });
    await _setupcamera();
  }

  Future<void> _saveToGallery(XFile picture) async {
    final save = await GallerySaver.saveImage(picture.path,albumName: 'MyAppGallery');
    if (save != null&&save) {
      print('Image Saved To Gallery');
    } else {
      print('Failed to save image');
    }
  }
}
