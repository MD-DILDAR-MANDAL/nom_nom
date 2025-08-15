import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:hive/hive.dart';
import 'package:nom_nom/model/history_item.dart';
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
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.initialize().then((_) {
      setState(() {
        _isCameraInitialized = true;
      });
    });
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              ? SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CameraPreview(_controller),
                  ),
                )
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
    final imageLabeler = ImageLabeler(
      options: ImageLabelerOptions(confidenceThreshold: 0.6),
    );
    final labels = await imageLabeler.processImage(inputImage);

    String labelList = labels.isNotEmpty
        ? labels
              .map(
                (l) =>
                    '${l.label} (${(l.confidence * 100).toStringAsFixed(1)}%)',
              )
              .join('\n')
        : "No labels found";

    var box = Hive.box('detection_history');
    await box.add(
      History(
        location: image.path,
        labels: labels.map((l) => l.label).toList(),
        timeStamp: DateTime.now(),
      ),
    );
    showDialog(
      context: context,
      builder: (_) {
        double scaleValue = 0.5;
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(Duration(milliseconds: 30), () {
              setState(() => scaleValue = 1.0);
            });
            return AlertDialog(
              icon: AnimatedScale(
                scale: scaleValue,
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
                child: SvgPicture.asset("assets/icons/cat.svg"),
              ),
              backgroundColor: secondary,
              title: Text(
                "Detected Labels",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                labelList,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
    ;

    await Future.delayed(Duration(milliseconds: 300));
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.speak(labelList.replaceAll('\n', '. '));
  }
}
