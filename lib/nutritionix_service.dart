import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionixService {
  static const String apiKey = "11749b5383ff160769ea2500f896a6bf";
  static const String appId = "95b53640";
  static const String baseUrl = "https://trackapi.nutritionix.com/v2";

  static Future<Map<String, dynamic>> fetchNutritionData(String query) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/natural/nutrients"),
        headers: {
          "x-app-id": appId,
          "x-app-key": apiKey,
          "Content-Type": "application/json",
        },
        body: json.encode({
          "query": query,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data["foods"][0]; // Returns the first food item
      } else {
        throw Exception("Failed to fetch nutritional data");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
