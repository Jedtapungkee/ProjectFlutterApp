import 'dart:convert';
import 'package:http/http.dart' as http;

class MealService {
  Future<List?> fetchMeals(String query) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'];
    } else {
      throw Exception('Failed to load meals');
    }
  }
}
