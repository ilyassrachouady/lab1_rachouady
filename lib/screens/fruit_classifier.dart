import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lab1_rachouady/robo_flow_service.dart'; // RoboflowAPI service
import 'package:lab1_rachouady/nutritionix_service.dart'; // NutritionixService
import 'package:flutter_spinkit/flutter_spinkit.dart'; // For animated spinner
import 'package:animate_do/animate_do.dart'; // For animations
import 'package:image_picker/image_picker.dart'; // For gallery picker

class ImageClassifier extends StatefulWidget {
  const ImageClassifier({super.key});

  @override
  _ImageClassifierState createState() => _ImageClassifierState();
}

class _ImageClassifierState extends State<ImageClassifier> {
  late CameraController _cameraController;
  bool _isCameraInitialized = false;
  File? _selectedImage;
  String _result = "Capture or select an image to classify.";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.first;

    _cameraController = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureImage() async {
    if (!_cameraController.value.isInitialized) return;

    setState(() {
      _isLoading = true;
      _result = "Classifying...";
    });

    try {
      final XFile imageFile = await _cameraController.takePicture();
      final File file = File(imageFile.path);

      setState(() {
        _selectedImage = file;
      });

      await _classifyImage(file);
    } catch (e) {
      setState(() {
        _result = "Error capturing image: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    setState(() {
      _isLoading = true;
      _result = "Classifying...";
    });

    try {
      final XFile? imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        final File file = File(imageFile.path);

        setState(() {
          _selectedImage = file;
        });

        await _classifyImage(file);
      } else {
        setState(() {
          _result = "No image selected.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = "Error selecting image: $e";
        _isLoading = false;
      });
    }
  }

  Future<void> _classifyImage(File imageFile) async {
    try {
      // Call Roboflow API to classify the image
      String classificationResult = await RoboflowAPI.classifyFruitImage(imageFile);
      String fruitName = classificationResult;

      setState(() {
        _result = "Prediction: $fruitName\nFetching nutrition info...";
      });

      // Fetch nutritional information
      var nutritionData = await NutritionixService.fetchNutritionData(fruitName);

      setState(() {
        _result = "Fruit: $fruitName\n"
            "Calories: ${nutritionData['nf_calories']}\n"
            "Carbs: ${nutritionData['nf_total_carbohydrate']}g\n"
            "Proteins: ${nutritionData['nf_protein']}g\n"
            "Fats: ${nutritionData['nf_total_fat']}g";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Fruit Classifier",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              // Camera Preview Section
              if (_isCameraInitialized)
                FadeIn(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: _cameraController.value.aspectRatio,
                      child: CameraPreview(_cameraController),
                    ),
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(),
                ),
              const SizedBox(height: 20),
              // Display Selected Image
              if (_selectedImage != null)
                FadeInDown(
                  child: Column(
                    children: [
                      Text(
                        "Selected Image",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 250),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              // Classification Result Section
              ZoomIn(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Classification Result",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_isLoading)
                        const SpinKitFadingCircle(
                          color: Colors.deepPurple,
                          size: 50.0,
                        )
                      else
                        Text(
                          _result,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Buttons for Capture and Gallery
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _captureImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.camera, color: Colors.white),
                    label: const Text(
                      "Capture",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text(
                      "Gallery",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: ImageClassifier()));
