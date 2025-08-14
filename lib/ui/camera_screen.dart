import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:nom_nom/theme_profile.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;
  const CameraScreen({super.key, required this.camera});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  late FlutterTts flutterTts;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _controller.initialize().then((_) {
      setState(() {
        _isCameraInitialized = true;
      });
    });
    flutterTts = FlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
            SvgPicture.asset("assets/icons/SUN.svg", height: 78),
          ],
        ),
      ),
      body: Stack(
        children: [
          _isCameraInitialized
              ? SizedBox.expand(child: CameraPreview(_controller))
              : Center(child: CircularProgressIndicator()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Center(
              child: FloatingActionButton(
                onPressed: _captureDetect,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureDetect() async {
    final image = await _controller.takePicture();

    final inputImage = InputImage.fromFilePath(image.path);
    final objectDetector = ObjectDetector(
      options: ObjectDetectorOptions(
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      ),
    );
    final objects = await objectDetector.processImage(inputImage);

    String title = objects.isNotEmpty && objects[0].labels.isNotEmpty
        ? objects[0].labels.first.text
        : "No object found";
    String details = objects.isNotEmpty && objects[0].labels.isNotEmpty
        ? "Confidence: ${objects[0].labels.first.confidence.toStringAsFixed(2)}"
        : "";

    final imageFile = File(image.path);
    final decodeFuture = imageFile.readAsBytes().then(
      (bytes) => painting.decodeImageFromList(bytes),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: FutureBuilder<ui.Image>(
            future: decodeFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final decodedImage = snapshot.data!;
              return LayoutBuilder(
                builder: (context, constraints) {
                  final double maxWidth = constraints.maxWidth;
                  final double maxHeight = constraints.maxHeight;
                  final double imageWidth = decodedImage.width.toDouble();
                  final double imageHeight = decodedImage.height.toDouble();
                  final scaleX = maxWidth / imageWidth;
                  final scaleY = maxHeight / imageHeight;

                  return Stack(
                    children: [
                      Image.file(
                        imageFile,
                        width: maxWidth,
                        height: maxHeight,
                        fit: BoxFit.contain,
                      ),
                      ...objects.map((obj) {
                        final boundingBox = obj.boundingBox;
                        return Positioned(
                          left: boundingBox.left * scaleX,
                          top: boundingBox.top * scaleY,
                          width: boundingBox.width * scaleX,
                          height: boundingBox.height * scaleY,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red, width: 3),
                            ),
                          ),
                        );
                      }).toList(),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              details,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
    await Future.delayed(Duration(milliseconds: 300));
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak('$title. $details');
  }
}
