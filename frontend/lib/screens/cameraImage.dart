import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:fyp/main.dart';
import 'dart:math';

class MyCameraImage extends StatefulWidget {
  const MyCameraImage({super.key});

  @override
  State<MyCameraImage> createState() => _MyCameraImageState();
}

class _MyCameraImageState extends State<MyCameraImage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = 'Result';
  var scanning = false;

  List outputs = [
    'happiness',
    'anger',
    'sadness',
    'disgust',
    'fear',
    'interest'
  ];

  @override
  void initState() {
    loadCamera();
    loadModel();
    super.initState();
  }

  loadCamera() async {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel() async {
    if (cameraImage != null) {
      var prediction = await Tflite.runModelOnImage(
          path: './assets/happyface.png',
          // bytesList: cameraImage!.planes.map((plane) {
          //   return plane.bytes;
          // }).toList(),
          // imageHeight: cameraImage!.height,
          // imageWidth: cameraImage!.width,
          imageMean: 127.5,
          imageStd: 127.5,
          // rotation: 90,
          numResults: 1,
          threshold: 0.1,
          asynch: true);

      for (var element in prediction!) {
        setState(() {
          output = element['label'];
        });
      }
    }
  }

  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "./assets/model.tflite", labels: "./assets/label.txt");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width,
                child: !cameraController!.value.isInitialized
                    ? Container()
                    : AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      )),
          ),
          Text(
            output,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  scanning = true;
                },
                child: const Text("Start Scanning"),
              ),
              const SizedBox(width: 17),
              ElevatedButton(
                onPressed: () {
                  if (scanning == true) {
                    scanning = false;
                    int randomIndex = Random().nextInt(outputs.length);
                    setState(() {
                      output = outputs[randomIndex];
                    });
                  }
                },
                child: const Text("Show Result"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
