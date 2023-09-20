import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(NextPage());
}

class NextPage extends StatefulWidget {
  final File? image;

  NextPage({Key? key, this.image}) : super(key: key);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  ColorFilter? _colorFilter;

  ColorFilter get activeFilter =>
      _colorFilter ??
      ColorFilter.mode(
        Colors.transparent,
        BlendMode.dst,
      );

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    screenshotController = ScreenshotController();
  }

  void _applyGreyscaleFilter() {
    setState(() {
      _colorFilter = ColorFilter.matrix(<double>[
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0.2126,
        0.7152,
        0.0722,
        0,
        0,
        0,
        0,
        0,
        1,
        0
      ]);
    });
  }

  void _applySepiaFilter() {
    setState(() {
      _colorFilter = ColorFilter.matrix(<double>[
        0.393,
        0.769,
        0.189,
        0,
        0,
        0.349,
        0.686,
        0.168,
        0,
        0,
        0.272,
        0.534,
        0.131,
        0,
        0,
        0,
        0,
        0,
        1,
        0,
      ]);
    });
  }

  void _applyInvertFilter() {
    setState(() {
      _colorFilter = ColorFilter.matrix(<double>[
        -1,
        0,
        0,
        0,
        255,
        0,
        -1,
        0,
        0,
        255,
        0,
        0,
        -1,
        0,
        255,
        0,
        0,
        0,
        1,
        0,
      ]);
    });
  }

  void _saveImageToGallery(BuildContext context) {
    screenshotController.capture().then((Uint8List? image) {
      _saveImage(image!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery'),
        ),
      );
    }).catchError((err) => print(err));
  }

  Future<void> _saveImage(Uint8List bytes) async {
    final time = DateTime.now().toIso8601String();
    final name = "filtered_image_$time";
    await _requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () =>
                _saveImageToGallery(context), // Call the save method here
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 31, 25, 25),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Screenshot(
            controller: screenshotController,
            child: Center(
              child: ColorFiltered(
                colorFilter: activeFilter,
                child: widget.image != null
                    ? Container(
                        width: 350.0,
                        height: 400.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: FileImage(widget.image!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Text('No image selected'),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _colorFilter = null;
                  });
                },
                child: Text('Original'),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: _applyGreyscaleFilter,
                child: Text('Greyscale'),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: _applySepiaFilter,
                child: Text('Sepia'),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: _applyInvertFilter,
                child: Text('Invert'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
