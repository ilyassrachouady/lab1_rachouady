import 'dart:io';
import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;

class IngredientRecognitionScreen extends StatefulWidget {
  const IngredientRecognitionScreen({super.key});

  @override
  _IngredientRecognitionScreenState createState() =>
      _IngredientRecognitionScreenState();
}

class _IngredientRecognitionScreenState
    extends State<IngredientRecognitionScreen> {
  File? _image;
  String _result = "No image processed yet";
  final ImagePicker _picker = ImagePicker();

  // Firebase setup - Initialize Firebase
  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Upload the image to Firebase Storage and return the image URL
  Future<String> _uploadImageToFirebase(File imageFile) async {
    try {
      // Create a reference to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child("ingredient_images/${DateTime.now().millisecondsSinceEpoch}.jpg");
      
      // Upload the image file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      
      // Get the download URL of the uploaded image
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      
      return downloadURL;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Call the Google Vision API using the image URL
  Future<String> detectIngredients(String imageUrl) async {
    const String apiKey = "AIzaSyDUlfmpOpt11NS7sypu5CLR-_WG-MTnhNk";  // Replace with your Google Vision API key
    const String apiUrl =
        "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

    final requestPayload = {
      "requests": [
        {
          "image": {
            "source": {"imageUri": imageUrl}
          },
          "features": [
            {"type": "LABEL_DETECTION", "maxResults": 5}
          ]
        }
      ]
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestPayload),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final labels = jsonResponse['responses'][0]['labelAnnotations']
          .map((annotation) => annotation['description'])
          .toList();
      return labels.join(', ');
    } else {
      return "Error: ${response.body}";
    }
  }

  // Capture or select an image
  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _processImage(_image!);
    }
  }

  // Process the image: upload it to Firebase, get URL and call Google Vision API
  Future<void> _processImage(File image) async {
    setState(() {
      _result = "Processing...";
    });

    try {
      // Upload image to Firebase Storage and get the URL
      String imageUrl = await _uploadImageToFirebase(image);
      
      // Call Google Vision API using the image URL
      String result = await detectIngredients(imageUrl);

      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Recognition'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Capture or Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}
