import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class RoboflowAPI {
  // Fruit classifier model
  static const String _fruitApiUrl = "https://classify.roboflow.com";
  static const String _fruitApiKey = "EGX6hloUaCZVLvQ7NDrI"; 
  static const String _fruitModelId = "fruits-kdfh9/1";

  // Fridgify ingredient detection model
  static const String _ingredientApiUrl = "https://detect.roboflow.com";
  static const String _ingredientApiKey = "EGX6hloUaCZVLvQ7NDrI"; 
  static const String _ingredientModelId = "fridgify/3"; 

  // Method to classify fruit image
  static Future<String> classifyFruitImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$_fruitApiUrl/$_fruitModelId?api_key=$_fruitApiKey"));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        Map<String, dynamic> predictions = jsonResponse['predictions'];
        String predictedClass = predictions.keys.firstWhere(
          (key) => predictions[key]['confidence'] == predictions.values.map((e) => e['confidence']).reduce((a, b) => a > b ? a : b),
        );

        return predictedClass;
      } else {
        throw Exception("Failed to classify fruit image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during fruit image classification: $e");
    }
  }

  // Method to classify ingredient image using the Fridgify model
  static Future<List<String>> classifyIngredientImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$_ingredientApiUrl/$_ingredientModelId?api_key=$_ingredientApiKey"));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        final String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        List<String> ingredients = [];
        for (var prediction in jsonResponse['predictions']) {
          ingredients.add(prediction['class']); // Add detected ingredient class to the list
        }

        return ingredients; // Return the list of detected ingredients
      } else {
        throw Exception("Failed to classify ingredient image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error during ingredient image classification: $e");
    }
  }
}
